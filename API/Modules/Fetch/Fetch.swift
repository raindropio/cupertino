import Foundation

final class DefaultFetchDelegate: FetchDelegate {
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
}

actor Fetch {
    private let base: URL
    private var delegate: FetchDelegate = DefaultFetchDelegate()
    private let session: URLSession = URLSession(configuration: .default)
    
    //dedup
    private var running: [URLRequest: Task<(Data, URLResponse), Error>] = [:]
    
    init(_ base: URL) {
        self.base = base
    }
    
    func setDelegate(_ delegate: FetchDelegate) {
        self.delegate = delegate
    }
}

//MARK: - Get
extension Fetch {
    func get<T: Decodable>(
        _ path: String,
        query: [URLQueryItem] = []
    ) async throws -> T {
        let (data, _) = try await request(
            try urlRequest(path, method: "GET", query: query)
        )
                
        return try await decode(data: data)
    }
}

//MARK: - Post
extension Fetch {
    func post<T: Decodable, R: Encodable>(
        _ path: String,
        query: [URLQueryItem] = [],
        body: R?
    ) async throws -> T {
        let (data, _) = try await request(
            try urlRequest(path, method: "POST", query: query, body: body)
        )
        
        return try await decode(data: data)
    }
    
    func post<T: Decodable>(
        _ path: String,
        query: [URLQueryItem] = []
    ) async throws -> T {
        try await post(path, query: query, body: Optional<Dumb>.none)
    }
}

//MARK: - Put
extension Fetch {
    func put<T: Decodable, R: Encodable>(
        _ path: String,
        query: [URLQueryItem] = [],
        body: R?
    ) async throws -> T {
        let (data, _) = try await request(
            try urlRequest(path, method: "PUT", query: query, body: body)
        )
        
        return try await decode(data: data)
    }
    
    func put<T: Decodable>(
        _ path: String,
        query: [URLQueryItem] = []
    ) async throws -> T {
        try await put(path, query: query, body: Optional<Dumb>.none)
    }
}

//MARK: - Delete
extension Fetch {
    func delete<T: Decodable, R: Encodable>(
        _ path: String,
        query: [URLQueryItem] = [],
        body: R?
    ) async throws -> T {
        let (data, _) = try await request(
            try urlRequest(path, method: "DELETE", query: query, body: body)
        )
        
        return try await decode(data: data)
    }
    
    func delete<T: Decodable>(
        _ path: String,
        query: [URLQueryItem] = []
    ) async throws -> T {
        try await delete(path, query: query, body: Optional<Dumb>.none)
    }
    
    func delete(
        _ path: String,
        query: [URLQueryItem] = []
    ) async throws {
        let _: Dumb = try await delete(path, query: query, body: Optional<Dumb>.none)
    }
}

//MARK: - Universal request
extension Fetch {
    func request(_ req: URLRequest) async throws -> (Data, URLResponse) {
        guard let url = req.url
        else { throw FetchError.invalidRequest(nil) }
        
        //keep only one running URLRequest same time
        if (!running.keys.contains(req)) {
            running[req] = Task{
                defer { running[req] = nil }
                
                let (data, response) = try await session.data(for: req)
                try Task.checkCancellation()
                
                return (data, response)
            }
        }
        
        //get and validate
        var result: (Data, URLResponse)
        
        do {
            result = try await running[req]!.value
        } catch {
            throw FetchError.invalidResponse(url, error.localizedDescription)
        }
        
        try await validate(data: result.0, res: result.1)
        
        return (result.0, result.1)
    }
    
    func urlRequest<R: Encodable>(
        _ path: String,
        method: String,
        query: [URLQueryItem] = [],
        body: R?
    ) throws -> URLRequest {
        var components = URLComponents()
        components.path = path
        components.queryItems = query
        
        guard let url = components.url(relativeTo: base)
        else { throw FetchError.invalidRequest(nil) }
        
        var req = URLRequest(url: url)
        req.httpMethod = method
        
        if let body {
            req.httpBody = try delegate.encoder.encode(body)
            req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return req
    }
    
    func urlRequest(
        _ path: String,
        method: String,
        query: [URLQueryItem] = []
    ) throws -> URLRequest {
        try urlRequest(path, method: method, query: query, body: Optional<Dumb>.none)
    }
    
    fileprivate struct Dumb: Codable {}
}

//MARK: - Validate
extension Fetch {
    func validate(data: Data, res: URLResponse) async throws {
        guard let url = res.url
        else { throw FetchError.invalidRequest(nil) }
        
        guard let httpResponse = res as? HTTPURLResponse
        else { throw FetchError.invalidResponse(url) }

        if !(200...304).contains(httpResponse.statusCode) {
            throw FetchError.invalidStatus(url, httpResponse.statusCode)
        }
        
        try await delegate.validate(data: data, res: res)
    }
}

//MARK: - Decode in separate thread
extension Fetch {
    func decode<T: Decodable>(data: Data) async throws -> T {
        do {
            return try await Task.detached {
                try await self.delegate.decoder.decode(T.self, from: data)
            }.value
        } catch {
            throw FetchError.decoding("\(error)")
        }
    }
}
