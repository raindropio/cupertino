import SwiftUI

extension NavigationPanes {
    struct Phone: View {
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
