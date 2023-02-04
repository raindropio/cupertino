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
                    Rest.authJWTStart(provider, deeplink: URL(string: "rnio://jwt")!),
                    scheme: "rnio"
                )
                
                guard let callbackUrl else { return }
                action(.jwt(callbackUrl))
            }
        }
        
        var body: some View {
            Menu {
                Button("Continue with") {}.disabled(true)
                
                Button { start(.google) } label: {
                    Label("Google", systemImage: "g.circle.fill")
                }
                
                Button { start(.facebook) } label: {
                    Label("Facebook", image: "facebook-circle-fill")
                }
                
                Button { start(.twitter) } label: {
                    Label("Twitter", image: "twitter-fill")
                }
                
                Button { start(.vkontakte) } label: {
                    Label("VK", image: "vk-fill")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .frame(width: height, height: height)
                    .background(.secondary.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
                .tint(.primary)
        }
    }
}
