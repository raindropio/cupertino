import SwiftUI

public struct WStack<C: View> {
    var alignment: Alignment
    var spacingX: Double
    var spacingY: Double
    // All items in line offered the height of the largest item
    var fillLineHeight: Bool
    var content: () -> C
    
    public init(
        alignment: Alignment = .leading,
        spacingX: Double = 10,
        spacingY: Double = 10,
        fillLineHeight: Bool = false,
        @ViewBuilder content: @escaping () -> C
    ) {
        self.alignment = alignment
        self.spacingX = spacingX
        self.spacingY = spacingY
        self.fillLineHeight = fillLineHeight
        self.content = content
    }
}

extension WStack: View {
    public var body: some View {
        if #available(iOS 16, *) {
            Modern(alignment: alignment, spacingX: spacingX, spacingY: spacingY, fillLineHeight: fillLineHeight) {
                content()
            }
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: alignment.vertical, spacing: spacingX, content: content)
            }
                .clipped()
        }
    }
}
