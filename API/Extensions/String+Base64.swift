import Foundation

extension String {
    var base64: String? {
        data(using: .utf8)?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) ?? ""
    }
}
