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
                        .navigationDestination(for: P.self, destination: detail)
                }
            } else {
                Backport.NavigationStack {
                    master()
                        .modifier(Sequence(path: $path, detail: detail))
                }
            }
        }
    }
}
