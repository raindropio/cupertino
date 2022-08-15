import SwiftUI

public extension DisclosureGroupStyle where Self == AutomaticDisclosureGroupStyle {
    #if os(iOS)
    static var tapable: TapableDisclosureGroupStyle { TapableDisclosureGroupStyle() }
    #else
    static var tapable: Self { .init() }
    #endif
}

#if os(iOS)
public struct TapableDisclosureGroupStyle: DisclosureGroupStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            Spacer()

            Image(systemName: "chevron.right")
                .padding(.horizontal, 4)
                .foregroundColor(.secondary)
                .fontWeight(.medium)
                .rotationEffect(
                    .degrees(configuration.isExpanded ? 90 : 0)
                )
                ._onButtonGesture { _ in } perform: {
                    withAnimation {
                        configuration.isExpanded.toggle()
                    }
                }
        }
    }
}
#endif
