import SwiftUI

public extension Backport where Wrapped: View {
    @ViewBuilder func glassEffect() -> some View {
        if #available(iOS 26.0, *) {
            content.glassEffect()
        } else {
            content
        }
    }
}
