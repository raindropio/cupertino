import SwiftUI
import UI

extension View {
    func addAction(to collection: Int? = nil) -> some View {
        modifier(AddActionModified(collection: collection))
    }
}

struct AddActionModified: ViewModifier {
    #if canImport(UIKit)
    @Environment(\.editMode) private var editMode
    #endif
    @Environment(\.isSearching) private var isSearching
    @State private var show = false

    //props
    var collection: Int?
    
    func body(content: Content) -> some View {
        content
            .fab(
                hide: editMode?.wrappedValue == .active || isSearching
            ) {
                Button { show = true } label: {
                    Image(systemName: "plus")
                }
                    .popover(isPresented: $show) {
                        AddStack(collection: collection)
                    }
            }
    }
}

