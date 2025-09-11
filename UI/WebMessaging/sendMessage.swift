import SwiftUI

public extension EnvironmentValues {
    var sendWebMessage: SendWebMessage {
        self[SendWebMessageEnvironmentKey.self]
    }
}

fileprivate struct SendWebMessageEnvironmentKey: EnvironmentKey {
    static let defaultValue = SendWebMessage()
}

public class SendWebMessage {
    let encoder = JSONEncoder()
    
    public func callAsFunction<M: Encodable>(@ObservedObject _ page: WebPage, channel: String, message: M) async throws {
        let data = try encoder.encode(message)
        let serialized = String(data: data, encoding: .utf8)
        if let serialized {
            try await page.evaluateJavaScript("window.\(channel)Send?.(\(serialized)); true")
        }
    }
}
