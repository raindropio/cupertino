import SwiftUI

extension WebView {
    struct ProgressBar: View {
        var value: Double
        
        var body: some View {
            Rectangle().fill(.tint)
                .frame(height: 3)
                .shadow(color: .accentColor.opacity(0.5), radius: 3, y: 1)
                .scaleEffect(x: value, anchor: .leading)
                .safeAnimation(.spring(), value: value)
                .opacity(value < 1 ? 1 : 0.01)
                .safeAnimation(.default, value: value)
                .allowsHitTesting(false)
        }
    }
}
