import SwiftUI
import UI
import API

extension CollectionForm.Fields {
    struct Icon: View {
        @State private var show = false
        @Binding var collection: UserCollection

        var body: some View {
            Button { show.toggle() } label: {
                CollectionIcon(collection, fallbackImageName: "photo")
                    .frame(height: 34)
            }
                .buttonStyle(.bordered)
                .buttonBorderShape(.roundedRectangle(radius: 6))
                .navigationDestination(isPresented: $show) {
                    CollectionIconGrid(selection: $collection.cover, suggest: collection.title)
                }
                .opacity(show ? 1 : 1) //fix navigationDestination
                .modifier(CollectionIconGrid.Preload(suggest: collection.title))
        }
    }
}
