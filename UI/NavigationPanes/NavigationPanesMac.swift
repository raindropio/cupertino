import SwiftUI

#if canImport(AppKit)
extension NavigationPanes {
    struct Mac: View {
        @Binding var path: P
        var sidebar: () -> S
        var detail: (P.Element?) -> D
        
        var body: some View {
            NavigationStack(path: $path) {
                sidebar()
                    .navigationDestination(for: P.Element.self, destination: detail)
            }
        }
    }
}
#endif
