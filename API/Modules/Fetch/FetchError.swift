import Foundation

public enum FetchError: LocalizedError, Codable {
    case invalidStatus(URL, Int)
    case invalidRequest(URL?, String? = nil)
    case invalidResponse(URL, String? = nil)
    case decoding(String? = nil)
    
    public var errorDescription: String? {
        switch self {
        case .invalidStatus(_, let statusCode): return HTTPURLResponse.localizedString(forStatusCode: statusCode)
        case .invalidRequest(_, let message): return message ?? "Invalid request"
        case .invalidResponse(_, let message): return message ?? "Invalid response"
        case .decoding(let message): return message ?? "Impossible to decode response"
        }
    }
}
