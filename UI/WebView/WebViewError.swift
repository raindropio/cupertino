import SwiftUI

struct WebViewError: View {
    @ObservedObject var service: WebViewService
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                Image(systemName: "exclamationmark.triangle")
                    .symbolVariant(.fill)
                    .foregroundStyle(.yellow)
                    .imageScale(.large)
                
                Text(service.error?.localizedDescription ?? "")
                    .multilineTextAlignment(.center)
            }
            
            Button("Retry") {
                service.webView.reload()
            }
                .buttonStyle(.bordered)
                .tint(.accentColor)
        }
            .padding()
    }
}
