import SwiftUI

public extension Backport where Wrapped: View {
    @available(iOS, deprecated: 16.0)
    @ViewBuilder
    func scrollContentBackground(_ visiblity: Visibility) -> some View {
        if #available(iOS 16, *) {
            content.scrollContentBackground(visiblity)
        } else {
            content
        }
    }
}
