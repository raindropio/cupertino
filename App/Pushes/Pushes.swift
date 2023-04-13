import SwiftUI
import API
import UI
import PushNotifications

struct Pushes: ViewModifier {
    @EnvironmentObject private var user: UserStore
    @Environment(\.openDeepLink) private var openDeepLink
    
    @Sendable
    private func registration() async {
        //link to user id (only for PRO)
        if let userId = user.state.me?.id, user.state.me?.pro == true {
            PushNotifications.shared.registerForRemoteNotifications()
            PushNotifications.shared.setUserId("\(userId)", tokenProvider: PusherTokenProvider.shared) { error in
                #if DEBUG
                if let error {
                    print(error)
                } else {
                    print("Successfully authenticated with Pusher Beams: \(userId)")
                }
                #endif
            }
        }
        //unlink all
        else {
            PushNotifications.shared.clearAllState {
                #if DEBUG
                print("Unlink Pusher Beams")
                #endif
            }
        }
    }
    
    func body(content: Content) -> some View {
        content
            .task(id: user.state.me?.id, registration)
            .task(id: user.state.me?.pro, registration)
    }
}
