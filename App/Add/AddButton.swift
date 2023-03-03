import SwiftUI
import UI

struct AddButton: View {
    @State private var present = false
    var collection: Int = -1

    var body: some View {
        Button { present.toggle() } label: {
            Image(systemName: "plus")
                .fontWeight(.semibold)
        }
            .popover(isPresented: $present) {
                AddPopover(collection: collection)
                    .frame(idealWidth: 400, idealHeight: 500)
            }
    }
}
