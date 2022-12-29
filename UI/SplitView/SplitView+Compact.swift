import SwiftUI
import Backport

extension SplitView {
    struct Compact: View {
        @Binding var path: [P]
        var master: () -> S
        @ViewBuilder var detail: (P) -> D

        var body: some View {
            if #available(iOS 16, *) {
                NavigationStack(path: $path) {
                    master()
                        .scopeEditMode()
                        .navigationDestination(for: P.self) {
                            detail($0)
                                .scopeEditMode()
                        }
                }
            } else {
                Backport.NavigationStack {
                    master()
                        .scopeEditMode()
                        .modifier(Sequence(path: $path) {
                            detail($0)
                                .scopeEditMode()
                        })
                }
            }
        }
    }
}
