import SwiftUI

public extension View {
    /// Style Section's appropriately for .grid layout. Ignored for .list layout
    func lazyStackSection() -> some View {
        #if canImport(UIKit)
        modifier(iOS())
        #else
        modifier(LSS())
        #endif
    }
}

fileprivate struct LSS: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.callout)
            .foregroundStyle(.secondary)
            .labelStyle(LSSLabelStyle())
            .buttonStyle(.borderless)
    }
}

#if canImport(UIKit)
fileprivate struct iOS: ViewModifier {
    @Environment(\.lazyStackLayout) private var layout
    
    func body(content: Content) -> some View {
        switch layout {
        case .list:
            content
            
        default:
            content.modifier(LSS())
        }
    }
}
#endif

fileprivate struct LSSLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
                .foregroundStyle(.primary)
                .labelStyle(.titleAndIcon)
        } icon: {
            configuration.icon
                .frame(minWidth: 28)
                .foregroundStyle(.tint)
        }
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.body)
        
        Divider()
    }
}
