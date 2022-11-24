import SwiftUI

public extension ButtonStyle where Self == GalleryButtonStyle {
    static var gallery: Self {
        return .init()
    }
}

public struct GalleryButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .labelStyle(GalleryLabelStyle())
            .padding(12)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(.foreground.opacity(configuration.isPressed ? 0.15 : 0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public struct GalleryLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            configuration.icon
                .symbolVariant(.fill)
                .foregroundStyle(.tint)
                .font(.system(size: 24))
                .frame(width: 24, height: 24)
                .padding(2)
            
            Spacer(minLength: 12)
                        
            configuration.title
                .foregroundStyle(.foreground)
        }
    }
}
