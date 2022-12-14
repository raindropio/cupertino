import SwiftUI

public extension Backport where Wrapped: View {
    @available(iOS, deprecated: 16.0)
    @ViewBuilder func alignmentGuide(_ g: Backport.HorizontalAlignment, computeValue: @escaping (ViewDimensions) -> CGFloat) -> some View {
        if #available(iOS 16, *) {
            content.alignmentGuide(g.convert, computeValue: computeValue)
        } else {
            content
        }
    }
}

extension Backport {
    public enum HorizontalAlignment {
        case listRowSeparatorLeading
        case listRowSeparatorTrailing
        
        @available(iOS 16, *)
        var convert: SwiftUI.HorizontalAlignment {
            switch self {
            case .listRowSeparatorLeading: return .listRowSeparatorLeading
            case .listRowSeparatorTrailing: return .listRowSeparatorLeading
            }
        }
    }
}
