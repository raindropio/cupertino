import SwiftUI

public struct GlassBackportButtonStyle: PrimitiveButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 26, *) {
            Button(configuration)
                .buttonStyle(.glass)
        } else {
            Button(configuration)
                .buttonStyle(.bordered)
        }
    }
}

public extension Backport {
    static var glass: GlassBackportButtonStyle { .init() }
}
