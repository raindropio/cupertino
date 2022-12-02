import SwiftUI

public extension Backport where Wrapped: View {
    @ViewBuilder func listSelectionFix() -> some View {
        if #available(iOS 16, *) {
            content
        } else {
            content
                .environment(\.editMode, .constant(.active))
        }
    }
}
