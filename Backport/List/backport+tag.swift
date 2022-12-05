import SwiftUI

public extension Backport where Wrapped: View {
    @ViewBuilder func tag<T: Hashable>(_ tag: T) -> some View {
        if #available(iOS 16, *) {
            content.tag(tag)
        } else {
            content
                .listItemBehaviour(tag)
                .tag(tag)
        }
    }
}
