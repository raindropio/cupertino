import SwiftUI

extension SplitView {
    struct Sequence: ViewModifier {
        @Binding var path: [P]
        var level = 0
        @ViewBuilder var detail: (P) -> D
        
        var isPresented: Binding<Bool> {
            .init {
                level <= path.count-1
            } set: {
                if !$0 {
                    path.removeSubrange(level...)
                }
            }
        }
        
        func body(content: Content) -> some View {
            content
                .background(
                    NavigationLink("", isActive: isPresented) {
                        if isPresented.wrappedValue {
                            detail(path[level])
                                .modifier(Self(path: $path, level: level+1, detail: detail))
                        }
                    }
                )
        }
    }
}
