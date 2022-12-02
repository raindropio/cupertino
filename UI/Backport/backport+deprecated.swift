import SwiftUI

public extension Backport where Wrapped: View {
    @ViewBuilder
    func deprecated<M: View>(modify: (Wrapped) -> M) -> some View {
        if #available(iOS 16, *) {
            content
        } else {
            modify(content)
        }
    }
}
