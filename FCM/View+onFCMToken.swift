import SwiftUI

public extension View {
    func onFCMToken(
        _ action: @Sendable @escaping (_ token: String) -> Void
    ) -> some View {
        modifier(OnFCMToken(action: action))
    }
}

fileprivate struct OnFCMToken: ViewModifier {
    var action: @Sendable (_ token: String) -> Void

    func body(content: Content) -> some View {
        content
            .onReceive(FCM.shared.token, perform: action)
    }
}
