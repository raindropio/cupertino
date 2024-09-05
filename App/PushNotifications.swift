import SwiftUI
import API
import UI
import FCM

struct PushNotifications: ViewModifier {
    @EnvironmentObject private var user: UserStore
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.openURL) private var openURL
   
    func body(content: Content) -> some View {
        content
            .onChange(of: user.state.me) { _ in
                FCM.shared.reloadToken()
            }
            .onFCMToken { token in
                Task {
                    try await dispatch(UserAction.connectFCMDevice(token))
                }
            }
            .onFCMMessage { message in
                let type = message["type"] as? String
                
                switch(type) {
                case "raindrop_reminder":
                    if
                        let link = message["link"] as? String,
                        let url = URL(string: link) {
                        openURL(url)
                    }
                default:
                    print("unknown fcm message", message)
                }
            }
    }
}
