import SwiftUI

public extension View {
    /// Style Section's appropriately for .grid layout. Ignored for .list layout
    func lazyStackSection() -> some View {
        modifier(LSS())
    }
}

fileprivate struct LSS: ViewModifier {
    @Environment(\.lazyStackLayout) private var layout
    
    func body(content: Content) -> some View {
        switch layout {
        case .list:
            content
            
        default:
            content
                .font(.callout)
                .foregroundStyle(.secondary)
                .labelStyle(LSSLabelStyle())
                .frame(maxWidth: .infinity, alignment: .leading)
                ._safeAreaInsets(.init(top: 2, leading: 16, bottom: 2, trailing: 16))
        }
    }
}

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

