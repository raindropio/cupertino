import SwiftUI

extension SplitView {
    struct Regular: View {
        @Binding var path: [P]
        var master: () -> S
        @ViewBuilder var detail: (P) -> D
        
        var isModalPresented: Binding<Bool> {
            .init {
                path.count > 1
            } set: {
                if !$0 {
                    path.removeLast(path.count - 1)
                }
            }
        }
        
        var body: some View {
            NavigationView {
                master()
                
                if let selected = path.first {
                    detail(selected)
                        .modifier(Sequence(path: $path, level: 1, detail: detail))
                }
            }
                .navigationViewStyle(.columns)
        }
    }
}
