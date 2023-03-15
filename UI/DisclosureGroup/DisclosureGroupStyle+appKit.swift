import SwiftUI

#if canImport(AppKit)
public extension DisclosureGroupStyle where Self == AppKitDisclosureStyle {
    static var appKit: Self {
        return .init()
    }
}

public struct AppKitDisclosureStyle: DisclosureGroupStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            Button { configuration.isExpanded.toggle() } label: {
                Image(systemName: "chevron.down")
                    .imageScale(.small)
                    .fontWeight(.semibold)
                    .rotationEffect(.degrees(configuration.isExpanded ? 0 : -90))
                    .frame(width: 10)
                    .frame(maxHeight: .infinity)
                    .padding(.trailing, 2)
                    .fixedSize(horizontal: true, vertical: false)
                    .contentShape(Rectangle())
            }
                .buttonStyle(.plain)
                .opacity(0.6)
                .layoutPriority(-1)
            
            configuration.label
        }
        
        if configuration.isExpanded {
            configuration.content
        }
    }
}
#endif
