import SwiftUI

public extension View {
    func onFCMMessage(
        @_inheritActorContext _ action: @Sendable @escaping (_ message: [AnyHashable : Any]) -> Void
    ) -> some View {
        modifier(OnFCMMessageModifier(action: action))
    }
}

fileprivate struct OnFCMMessageModifier: ViewModifier {
    var action: @Sendable (_ message: [AnyHashable : Any]) -> Void

    func body(content: Content) -> some View {
        content
            .onReceive(FCM.shared.messages, perform: action)
    }
}
