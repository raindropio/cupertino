import SwiftUI

public extension Backport where Wrapped: View {
    @available(iOS, deprecated: 16.0)
    @ViewBuilder
    func lineLimit(_ limit: PartialRangeFrom<Int>) -> some View {
        if #available(iOS 16, *) {
            content.lineLimit(limit)
        } else {
            content
            //TODO: Backport
        }
    }
    
    @available(iOS, deprecated: 16.0)
    @ViewBuilder
    func lineLimit(_ limit: ClosedRange<Int>) -> some View {
        if #available(iOS 16, *) {
            content.lineLimit(limit)
        } else {
            content.lineLimit(limit.upperBound)
        }
    }
}
