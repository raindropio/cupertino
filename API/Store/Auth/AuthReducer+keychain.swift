import Foundation

extension AuthReducer {
    func restore() { KeychainCookies.restore() }
    func persist() { KeychainCookies.persist() }
}
