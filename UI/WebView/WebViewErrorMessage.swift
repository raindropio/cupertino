import SwiftUI

struct WebViewErrorMessage: View {
    @ObservedObject var page: WebPage
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                Image(systemName: "exclamationmark.triangle")
                    .symbolVariant(.fill)
                    .foregroundStyle(.yellow)
                    .imageScale(.large)
                
                Text(page.error?.localizedDescription ?? "")
                    .multilineTextAlignment(.center)
            }
            
            Button(action: page.reload) {
                Label("Reload", systemImage: "arrow.clockwise")
            }
                .buttonStyle(.bordered)
                .tint(.accentColor)
        }
            .padding()
    }
}
