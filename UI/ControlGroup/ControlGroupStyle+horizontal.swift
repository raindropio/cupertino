import SwiftUI

public extension ControlGroupStyle where Self == HorizontalControlGroupStyle {
    static var horizontal: Self {
        return .init()
    }
}

public struct HorizontalControlGroupStyle: ControlGroupStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            configuration.content
        }
            .buttonStyle(HorizontalControlGroupButtonStyle())
            .listRowInsets(EdgeInsets())
    }
}

fileprivate struct HorizontalControlGroupButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(configuration.role == .destructive ? AnyShapeStyle(.red) : AnyShapeStyle(.tint))
            .background(.primary.opacity(configuration.isPressed ? 0.13 : 0))
            .background(alignment: .trailing) {
                HStack(content: Divider.init)
                    .offset(x: 1)
                    .allowsHitTesting(false)
            }
            .contentShape(Rectangle())
    }
}
