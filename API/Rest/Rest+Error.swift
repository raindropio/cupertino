import Foundation

public enum RestError: LocalizedError, Equatable {
    case unknown(String? = nil)
    case unauthorized
    case forbidden
    case notFound
    case invalid(String? = nil)
    case tfaRequired(token: String)
    
    case appleAuthCredentialsInvalid
    case jwtAuthCallbackURLInvalid
    
    case subscriptionRestoreReceiptInvalid
    case purchaseHavePending
    case purchaseUnknownStatus
    
    public var errorDescription: String? {
        switch self {
        case .unknown(let message): return message ?? "Unknown error"
        case .unauthorized: return "Please login first"
        case .forbidden: return "You don't have access"
        case .notFound: return "Nothing found"
        case .invalid(let message): return message ?? "Invalid request"
        case .tfaRequired(_): return "2FA required"
            
        case .appleAuthCredentialsInvalid: return "can't get apple sign in credentials"
        case .jwtAuthCallbackURLInvalid: return "callback url doesn't have token"
            
        case .subscriptionRestoreReceiptInvalid: return "receipt invalid"
        case .purchaseHavePending: return "Purchase is pending. Please tap Restore later"
        case .purchaseUnknownStatus: return "Unknown status. Please tap Restore later"
        }
    }
}
