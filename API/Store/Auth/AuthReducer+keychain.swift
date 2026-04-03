import Foundation

extension AuthReducer {
    func restore() { KeychainCookies.restore() }
    func persist() { KeychainCookies.persist() }
    func cleanup() { KeychainCookies.cleanup() }
}
