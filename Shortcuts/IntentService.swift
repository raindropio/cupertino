import AppIntents
import API

enum IntentServiceError: Error, CustomLocalizedStringResourceConvertible {
    case notAuthenticated
    case bookmarkNotFound

    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .notAuthenticated: "Please log in to Raindrop.io first"
        case .bookmarkNotFound: "Bookmark not found"
        }
    }
}

final class IntentService {
    static let shared = IntentService()

    let rest = Rest()
    private var cookiesRestored = false

    private init() {}

    func perform<T>(_ block: (Rest) async throws -> T) async throws -> T {
        if !cookiesRestored {
            KeychainCookies.restore()
            cookiesRestored = true
        }
        do {
            return try await block(rest)
        } catch RestError.unauthorized {
            throw IntentServiceError.notAuthenticated
        }
    }
}
