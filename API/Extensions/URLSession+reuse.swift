import Foundation

fileprivate actor Deduper {
    static var shared = Deduper()
    private var inflight = [URLRequest: Task<(Data, URLResponse), Error>]()
    private var waiting = [URLRequest: Int]()
    
    func reuse(_ req: URLRequest, session: URLSession) async throws -> (Data, URLResponse) {
        if inflight[req] == nil {
            inflight[req] = Task {
                return try await session.data(for: req)
            }
        }
        
        waiting[req] = (waiting[req] ?? 0) + 1
        let result = try await inflight[req]!.value
        
        waiting[req] = (waiting[req] ?? 0) - 1
                
        if waiting[req]! <= 0 {
            inflight.removeValue(forKey: req)
            waiting.removeValue(forKey: req)
        }
        
        return result
    }
}

extension URLSession {
    /// Prevent calling already loading request, just reuse
    func reuse(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await Deduper.shared.reuse(request, session: self)
    }
}
