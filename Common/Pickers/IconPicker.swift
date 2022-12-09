import SwiftUI
import UI
import API

struct IconPicker: View {
    @Binding var selection: URL?

    var body: some View {
        NavigationLink {
            Page(selection: $selection)
        } label: {
            Group {
                if let selection {
                    Thumbnail(selection, width: 64, height: 64)
                } else {
                    Button("Select icon") {}
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .tint(.secondary)
                        .allowsHitTesting(false)
                }
            }
                .frame(maxWidth: .infinity)
        }
            .clearSection()
    }
}

extension IconPicker {
    struct Page: View {
        @Environment(\.dismiss) private var dismiss
        
        @EnvironmentObject private var i: IconsStore
        @EnvironmentObject private var dispatch: Dispatcher
        @Binding var selection: URL?
        @SceneStorage("select-icon-filter") private var search = ""
        
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
                .searchable(text: $search, debounce: 0.3, placement: .navigationBarDrawer(displayMode: .always))
                .toolbar {
                    ToolbarItem(placement: .destructiveAction) {
                        Button("None") {
                            selection = nil
                        }
                    }
                }
                .task(id: search, priority: .background) {
                    try? await dispatch(IconsAction.load(search))
                }
                .onChange(of: selection) { _ in
                    dismiss()
                }
        }
    }
}
