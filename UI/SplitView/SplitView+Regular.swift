import SwiftUI

extension SplitView {
    struct Regular: View {
        @Binding var path: [P]
        var master: () -> S
        @ViewBuilder var detail: (P) -> D
        
        var subPath: Binding<[P]> {
            .init {
                path.count >= 1 ? [P].init(path[1...]) : []
            } set: {
                path = (path.first != nil ? [path.first!] : []) + $0
            }
        }
        
        var body: some View {
            if #available(iOS 16, *) {
                NavigationSplitView {
                    master()
                        .detachedEditMode()
                } detail: {
                    NavigationStack(path: subPath) {
                        Group {
                            if let selected = path.first {
                                detail(selected)
                                    .detachedEditMode()
                            }
                        }
                            .navigationDestination(for: P.self) {
                                detail($0)
                                    .detachedEditMode()
                            }
                    }
                }
            } else {
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
}
