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
                Page(selection: $collection.cover, suggest: collection.title)
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
        @State private var search = ""
        
        @Binding var selection: URL?
        var suggest: String = ""
        
        var isLoading: Bool {
            i.state.loading(search) || i.state.loading(suggest)
        }
        
        var icons: [URL] {
            i.state.filtered(search)
        }
        
        var suggestions: [URL] {
            i.state.filtered(suggest)
        }
        
        var body: some View {
            ScrollView(.vertical) {
                if search.isEmpty, !suggest.isEmpty, !suggestions.isEmpty {
                    ImagePicker(
                        suggestions,
                        selection: $selection,
                        width: 48, height: 48
                    )
                        .equatable()
                }
                
                ImagePicker(
                    icons,
                    selection: $selection,
                    width: 48, height: 48
                )
                    .equatable()
            }
                .ignoresSafeArea(.keyboard)
                .overlay {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.regularMaterial)
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
                .task(id: suggest, priority: .background) {
                    try? await dispatch(IconsAction.load(suggest))
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
