import SwiftUI
import Backport

#if canImport(UIKit)
fileprivate let defaultSpacing: [ControlSize: CGFloat] = [
    .large: 14,
    .regular: 12,
    .small: 10,
    .mini: 8
]
#else
fileprivate let defaultSpacing: [ControlSize: CGFloat] = [
    .large: 10,
    .regular: 8,
    .small: 6,
    .mini: 4
]
#endif

public struct StripStack<C: View> {
    @Environment(\.controlSize) private var controlSize
    
    var spacing: CGFloat?
    var content: () -> C
    
    public init(spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> C) {
        self.spacing = spacing
        self.content = content
    }
}

#if canImport(UIKit)
extension StripStack: View {
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: spacing ?? defaultSpacing[controlSize], content: content)
                .padding(.trailing, 32)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
            .backport.scrollBounceBehavior(.basedOnSize, axes: [.horizontal, .vertical])
            .mask {
                LinearGradient(
                    gradient: Gradient(colors: Array(repeating: .black, count: 7) + [.clear]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                    .allowsHitTesting(false)
            }
    }
}
#else
extension StripStack: View {
    public var body: some View {
        WStack(spacingX: spacing ?? defaultSpacing[controlSize]!, spacingY: spacing ?? defaultSpacing[controlSize]!, content: content)
    }
}
#endif
