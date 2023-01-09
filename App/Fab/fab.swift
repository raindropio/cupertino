import SwiftUI
import UI

extension View {
    func fab(to collection: Int = -1, hidden: Bool = false) -> some View {
        modifier(FabModifier(collection: collection, hidden: hidden))
    }
}

fileprivate struct FabModifier: ViewModifier {
    @Environment(\.editMode) private var editMode
    @EnvironmentObject private var app: AppRouter

    @State private var present = false
    var collection: Int
    var hidden: Bool
    
    func body(content: Content) -> some View {
        content
            .floatingActionButton(
                hide: hidden || editMode?.wrappedValue == .active || app.spotlight
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
