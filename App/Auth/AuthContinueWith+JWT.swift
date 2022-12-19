import SwiftUI
import AuthenticationServices
import API

extension AuthContinueWith {
    struct JWT: View {
        var action: (_ action: AuthAction) -> Void
        
        var body: some View {
            Menu {
                Button("Continue with") {}.disabled(true)
                
                Button {
                    
                } label: {
                    Label("Google", systemImage: "g.circle.fill")
                }
                    .tint(.red)
                    .labelStyle(.iconOnly)
                
                Button {
                    
                } label: {
                    Label("Facebook", image: "facebook-circle-fill")
                }
                
                Button {
                    
                } label: {
                    Label("Twitter", image: "twitter-fill")
                }
                
                Button {
                    
                } label: {
                    Label("VK", image: "vk-fill")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .backport.fontWeight(.bold)
                    .frame(width: 22, height: 32)
            }
                .tint(.black)
                .buttonStyle(.borderedProminent)
        }
    }
}
