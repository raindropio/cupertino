import SwiftUI
import Combine

public extension EnvironmentValues {
    var openDeepLink: OpenDeepLinkAction? {
        get {
            self[OpenDeepLinkKey.self]
        } set {
            self[OpenDeepLinkKey.self] = newValue
        }
    }
}

public class OpenDeepLinkAction {
    let publisher: PassthroughSubject<DeepLinkDestination, Never> = PassthroughSubject()
    
    public func callAsFunction(_ destination: DeepLinkDestination) {
        publisher.send(destination)
    }
}

private struct OpenDeepLinkKey: EnvironmentKey {
    static let defaultValue: OpenDeepLinkAction? = nil
}
