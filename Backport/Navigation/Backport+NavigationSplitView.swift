import SwiftUI

@available(iOS, deprecated: 16.0)
public extension Backport where Wrapped == Any {
    @ViewBuilder
    static func NavigationSplitView<S: View, D: View>(
        @ViewBuilder sidebar: () -> S,
        @ViewBuilder detail: () -> D
    ) -> some View {
        if #available(iOS 16, *) {
            SwiftUI.NavigationSplitView(sidebar: sidebar, detail: detail)
        } else {
            NSV(sidebar: sidebar(), detail: detail())
        }
    }
}

fileprivate struct NSV<S: View, D: View>: View {
    var sidebar: S
    var detail: D

    var body: some View {
        SwiftUI.NavigationView {
            sidebar
            detail
                .navigationBarHidden(true)
        }
            .navigationViewStyle(.columns)
    }
}
