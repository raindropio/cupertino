import SwiftUI
import UI

extension View {
    func fab(to collection: Int = -1) -> some View {
        modifier(FabModifier(collection: collection))
    }
}

fileprivate struct FabModifier: ViewModifier {
    @Environment(\.editMode) private var editMode
    @Environment(\.isSearching) private var isSearching

    @State private var present = false
    var collection: Int
    
    func body(content: Content) -> some View {
        content
            .floatingActionButton(
                hide: editMode?.wrappedValue == .active || isSearching
            ) {
                Button {
                    present.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                    .popover(isPresented: $present) {
                        FabStack(collection: collection)
                            .frame(idealWidth: 400, idealHeight: 500)
                    }
            }
    }
}
