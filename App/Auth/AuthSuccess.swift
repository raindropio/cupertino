import SwiftUI
import Features

struct AuthSuccess: ViewModifier {
    func body(content: Content) -> some View {
        AuthGroup {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .font(.system(size: 56, weight: .semibold))
        } notAuthorized: {
            content
        }
    }
}
