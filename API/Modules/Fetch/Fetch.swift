import Foundation

private let session = URLSession(configuration: {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 30
    configuration.timeoutIntervalForResource = 300 // 5 min for large uploads
    configuration.waitsForConnectivity = false
    return configuration
}())

private let inFlightCache = InFlightCache()

final class DefaultFetchDelegate: FetchDelegate {
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
}

final class Fetch {
    private let base: URL
    private var delegate: FetchDelegate = DefaultFetchDelegate()
    
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
        query: [URLQueryItem]? = nil
    ) async throws -> T {
        let (data, _) = try await request(
            try urlRequest(path, method: "GET", query: query)
        )
                
        return try decode(data: data)
    }
    
    func get(
        _ path: String,
        query: [URLQueryItem]? = nil
    ) async throws -> String? {
        let (data, _) = try await request(
            try urlRequest(path, method: "GET", query: query)
        )
                
        return String(bytes: data, encoding: .utf8)
    }
}

//MARK: - Post
extension Fetch {
    func post<T: Decodable, R: EncodableWithConfiguration>(
        _ path: String,
        query: [URLQueryItem]? = nil,
        body: R,
        configuration: R.EncodingConfiguration
    ) async throws -> T {
        let (data, _) = try await request(
            try urlRequest(path, method: "POST", query: query, body: body, configuration: configuration)
        )
        
        return try decode(data: data)
    }
    
    func post<T: Decodable, R: Encodable>(
        _ path: String,
        query: [URLQueryItem]? = nil,
        body: R
    ) async throws -> T {
        let (data, _) = try await request(
            try urlRequest(path, method: "POST", query: query, body: body)
        )
        
        return try decode(data: data)
    }
    
    func post<R: Encodable>(
        _ path: String,
        query: [URLQueryItem]? = nil,
        body: R
    ) async throws {
        _ = try await request(
            try urlRequest(path, method: "POST", query: query, body: body)
        )
    }
    
    func post<T: Decodable>(
        _ path: String,
        query: [URLQueryItem]? = nil
    ) async throws -> T {
        let (data, _) = try await request(
            try urlRequest(path, method: "POST", query: query)
        )
        
        return try decode(data: data)
    }
}

//MARK: - Put
extension Fetch {
    func put<T: Decodable, R: EncodableWithConfiguration>(
        _ path: String,
        query: [URLQueryItem]? = nil,
        body: R,
        configuration: R.EncodingConfiguration
    ) async throws -> T {
        let (data, _) = try await request(
            try urlRequest(path, method: "PUT", query: query, body: body, configuration: configuration)
        )
        
        return try decode(data: data)
    }
    
    func put<T: Decodable, R: Encodable>(
        _ path: String,
        query: [URLQueryItem]? = nil,
        body: R
    ) async throws -> T {
        let (data, _) = try await request(
            try urlRequest(path, method: "PUT", query: query, body: body)
        )
        
        return try decode(data: data)
    }
    
    func put<T: Decodable>(
        _ path: String,
        query: [URLQueryItem]? = nil
    ) async throws -> T {
        let (data, _) = try await request(
            try urlRequest(path, method: "PUT", query: query)
        )
        
        return try decode(data: data)
    }
    
    func put<T: Decodable>(
        _ path: String,
        query: [URLQueryItem]? = nil,
        formData: FormData
    ) async throws -> T {
        let (data, _) = try await request(
            try urlRequest(path, method: "PUT", query: query, formData: formData)
        )
        
        return try decode(data: data)
    }
}

//MARK: - Delete
extension Fetch {
    func delete<T: Decodable, R: Encodable>(
        _ path: String,
        query: [URLQueryItem]? = nil,
        body: R
    ) async throws -> T {
        let (data, _) = try await request(
            try urlRequest(path, method: "DELETE", query: query, body: body)
        )
        
        return try decode(data: data)
    }
    
    func delete<T: Decodable>(
        _ path: String,
        query: [URLQueryItem]? = nil
    ) async throws -> T {
        let (data, _) = try await request(
            try urlRequest(path, method: "DELETE", query: query)
        )
        
        return try decode(data: data)
    }
    
    func delete(
        _ path: String,
        query: [URLQueryItem]? = nil
    ) async throws {
        _ = try await request(
            try urlRequest(path, method: "DELETE", query: query)
        )
    }
}

//MARK: - Head
extension Fetch {
    func head(
        _ path: String,
        query: [URLQueryItem]? = nil
    ) async throws -> URLResponse {
        let (_, res) = try await request(
            try urlRequest(path, method: "HEAD", query: query)
        )

        return res
    }
}

//MARK: - Universal request
extension Fetch {
    func request(_ req: URLRequest) async throws -> (Data, URLResponse) {
        guard let url = req.url
        else { throw FetchError.invalidRequest(nil) }
        
        #if DEBUG
        let start = Date()
        #endif

        //get and validate
        var result: (Data, URLResponse)

        do {
            if req.httpMethod == "GET" {
                result = try await inFlightCache.deduplicated(for: url) {
                    try await session.data(for: req)
                }
            } else {
                result = try await session.data(for: req)
            }

            #if DEBUG
            let elapsed = Date().timeIntervalSince(start)
            if elapsed > 0.5 {
                print("Slow request: \(req.httpMethod ?? "") \(req.url?.absoluteString ?? "") took \(String(format: "%.2f", elapsed))s")
            }
            #endif
        } catch {
            #if DEBUG
            print(req.httpMethod ?? "", req.url?.absoluteString ?? "", error.localizedDescription)
            #endif
            try Task.checkCancellation()
            throw FetchError.invalidResponse(url, error.localizedDescription)
        }
        
        try await validate(data: result.0, res: result.1)
        
        return (result.0, result.1)
    }
    
    func urlRequest(
        _ path: String,
        method: String,
        query: [URLQueryItem]? = nil
    ) throws -> URLRequest {
        var components = URLComponents()
        components.path = path
        components.queryItems = query
        
        //fix `+` query encoding
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        guard let url = components.url(relativeTo: base)
        else { throw FetchError.invalidRequest(nil) }
        
        var req = URLRequest(url: url)
        req.httpMethod = method
        
        return req
    }
    
    func urlRequest<R: Encodable>(
        _ path: String,
        method: String,
        query: [URLQueryItem]? = nil,
        body: R
    ) throws -> URLRequest {
        var req = try urlRequest(path, method: method, query: query)
        req.httpBody = try delegate.encoder.encode(body)
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return req
    }
    
    func urlRequest<R: EncodableWithConfiguration>(
        _ path: String,
        method: String,
        query: [URLQueryItem]? = nil,
        body: R,
        configuration: R.EncodingConfiguration
    ) throws -> URLRequest {
        var req = try urlRequest(path, method: method, query: query)
        req.httpBody = try delegate.encoder.encode(body, configuration: configuration)
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return req
    }
    
    func urlRequest(
        _ path: String,
        method: String,
        query: [URLQueryItem]? = nil,
        formData: FormData
    ) throws -> URLRequest {
        var req = try urlRequest(path, method: method, query: query)
        
        let boundary = "Boundary-\(UUID().uuidString)"
        let (stream, length) = try formData.buildStream(boundary: boundary)

        req.httpBodyStream = stream
        req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        req.setValue(String(length), forHTTPHeaderField: "Content-Length")
        
        return req
    }
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
        
        do {
            try await delegate.validate(data: data, res: res)
        } catch {
            try Task.checkCancellation()
            throw error
        }
    }
}

extension Fetch {
    func decode<T: Decodable>(data: Data) throws -> T {
        try delegate.decoder.decode(T.self, from: data)
    }
}

