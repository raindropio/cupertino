import Foundation

public enum RestError: LocalizedError, Equatable {
    case unknown(String? = nil)
    case unauthorized
    case forbidden
    case notFound
    case invalid(String? = nil)
    
    public var errorDescription: String? {
        switch self {
        case .unknown(let message): return message ?? "Unknown error"
        case .unauthorized: return "Please login first"
        case .forbidden: return "You don't have access"
        case .notFound: return "Nothing found"
        case .invalid(let message): return message ?? "Invalid request"
        }
    }
}
