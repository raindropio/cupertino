import SwiftUI
import UI
import API

struct IconPicker: View {
    @Binding var collection: UserCollection

    var body: some View {
        ZStack {
            CollectionIcon(collection)
                .imageScale(.large)
                .symbolVariant(.fill)
            
            NavigationLink {
                Page(selection: $collection.cover)
            } label: {}
                .layoutPriority(-1)
                .opacity(0.00001)
        }
    }
}

extension IconPicker {
    struct Page: View {
        @Environment(\.dismiss) private var dismiss
        
        @EnvironmentObject private var i: IconsStore
        @EnvironmentObject private var dispatch: Dispatcher
        @Binding var selection: URL?
        @State private var search = ""
        
        var isLoading: Bool {
            i.state.loading(search)
        }
        
        var icons: [URL] {
            i.state.filtered(search)
        }
        
        var body: some View {
            ImagePicker(
                icons,
                selection: $selection,
                width: 48, height: 48
            )
                .equatable()
                .overlay {
                    if isLoading {
                        ProgressView()
                    }
                }
                .animation(.default, value: isLoading)
                .navigationTitle("Icon")
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always))
                .toolbar {
                    ToolbarItem(placement: .destructiveAction) {
                        Button("None") {
                            selection = nil
                        }
                    }
                }
                .task(id: search, priority: .background, debounce: 0.3) {
                    try? await dispatch(IconsAction.load(search))
                }
                .onChange(of: selection) { _ in
                    dismiss()
                }
        }
    }
}
