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
        case .unknown(let message): return message ?? String(localized: "Unknown error")
        case .unauthorized: return String(localized: "Please log in first")
        case .forbidden: return String(localized: "You don't have access")
        case .notFound: return String(localized: "Nothing found")
        case .invalid(let message): return message ?? String(localized: "Invalid request")
        case .tfaRequired(_): return String(localized: "2FA required")

        case .appleAuthCredentialsInvalid: return String(localized: "can't get apple sign in credentials")
        case .jwtAuthCallbackURLInvalid: return String(localized: "callback url doesn't have token")

        case .subscriptionRestoreReceiptInvalid: return String(localized: "receipt invalid")
        case .purchaseHavePending: return String(localized: "Purchase is pending. Please tap Restore later")
        case .purchaseUnknownStatus: return String(localized: "Unknown status. Please tap Restore later")
        }
    }
}
