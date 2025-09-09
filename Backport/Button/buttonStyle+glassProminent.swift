import SwiftUI

public struct GlassProminentBackportButtonStyle: PrimitiveButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 26, *) {
            Button(configuration)
                .buttonStyle(.glassProminent)
        } else {
            Button(configuration)
                .buttonStyle(.borderedProminent)
        }
    }
}

public extension Backport {
    static var glassProminent: GlassProminentBackportButtonStyle { .init() }
}
