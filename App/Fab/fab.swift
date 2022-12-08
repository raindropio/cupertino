import SwiftUI
import UI

extension View {
    func fab(to collection: Int = -1) -> some View {
        modifier(FabModifier(collection: collection))
    }
}

fileprivate struct FabModifier: ViewModifier {
    @State private var show = false
    var collection: Int
    
    func body(content: Content) -> some View {
        content
            .floatingActionButton {
                Button {
                    show = true
                } label: {
                    Image(systemName: "plus")
                }
                    .popover(isPresented: $show) {
                        FabStack(collection: collection)
                            .frame(idealWidth: 400, idealHeight: 500)
                    }
            }
    }
}
