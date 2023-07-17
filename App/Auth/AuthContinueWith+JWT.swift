import SwiftUI
import AuthenticationServices
import API
import UI

extension AuthContinueWith {
    struct JWT: View {
        @StateObject private var webAuth = WebAuth()
        @Environment(\.defaultMinListRowHeight) private var height
        
        var action: (_ action: AuthAction) -> Void
        
        private func start(_ provider: Rest.AuthNativeProvider) {
            Task {
                let callbackUrl = try? await webAuth(
                    Rest.authJWTStart(provider, deeplink: URL(string: "raindrop://jwt")!),
                    scheme: "raindrop"
                )
                
                guard let callbackUrl else { return }
                action(.jwt(callbackUrl))
            }
        }
        
        var body: some View {
            HStack {
                Button { start(.facebook) } label: {
                    Label("Facebook", image: "facebook-circle-fill")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                Button { start(.vkontakte) } label: {
                    Label("VK", image: "vk-fill")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
                .buttonStyle(.bordered)
                .labelStyle(.iconOnly)
        }
    }
}
