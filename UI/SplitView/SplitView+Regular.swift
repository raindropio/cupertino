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
                
                Group {
                    if let selected = path.first {
                        detail(selected)
                    }
                }
            }
                .navigationViewStyle(.columns)
                .fullScreenCover(isPresented: isModalPresented) {
                    NavigationView {
                        if path.count > 1 {
                            detail(path[1])
                                .toolbar {
                                    ToolbarItem(placement: .cancellationAction) {
                                        Button {
                                            isModalPresented.wrappedValue = false
                                        } label: {
                                            Image(systemName: "chevron.left")
                                                .font(.headline)
                                                .frame(width: 88, height: 44, alignment: .leading)
                                                .contentShape(Rectangle())
                                        }
                                        .offset(x: -8)
                                    }
                                }
                                .modifier(Sequence(path: $path, level: 2, detail: detail))
                        }
                    }
                }
        }
    }
}
