import SwiftUI
import API
import UI
#if os(iOS)
import PushNotifications
#endif

struct ReceivePush: ViewModifier {
    @EnvironmentObject private var user: UserStore
    @Environment(\.openURL) private var openURL
    
    @Sendable
    private func registration() async {
        if let user = user.state.me, user.pro {
            AppPushes.shared.link(userId: user.id)
        } else {
            AppPushes.shared.unlink()
        }
    }
    
    private func pushPressed() {
        guard let pressed = AppPushes.shared.pressed else { return }
        
        switch pressed {
        case .raindrop(let link):
            openURL(link)
        }
    }
    
    func body(content: Content) -> some View {
        content
            .task(id: user.state.me, registration)
            .onAppear(perform: pushPressed)
            .onReceive(NotificationCenter.default.publisher(for: .pushPressed)) { _ in
                pushPressed()
            }
    }
}
