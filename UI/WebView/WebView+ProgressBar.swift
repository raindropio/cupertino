import SwiftUI

extension WebView {
    struct ProgressBar: View {
        var value: Double
        
        var body: some View {
            Rectangle().fill(.tint)
                .frame(height: 3)
                .shadow(color: .accentColor.opacity(0.5), radius: 3, y: 1)
                .scaleEffect(x: value, anchor: .leading)
                .animation(.spring(), value: value)
                .opacity(value < 1 ? 1 : 0)
                .animation(.default, value: value)
        }
    }
}
