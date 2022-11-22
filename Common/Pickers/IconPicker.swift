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
        
        @EnvironmentObject private var icons: IconsStore
        @EnvironmentObject private var dispatch: Dispatcher
        @Binding var selection: URL?
        @SceneStorage("select-icon-filter") private var filter = ""
        
        var body: some View {
            ImagePicker(
                icons.state.filtered(filter),
                selection: $selection,
                width: 48, height: 48
            )
                .equatable()
                .navigationTitle("Icon")
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .filterable(text: $filter)
                .toolbar {
                    ToolbarItem(placement: .destructiveAction) {
                        Button("None") {
                            selection = nil
                        }
                    }
                }
                .task(id: filter, priority: .background) {
                    try? await dispatch(IconsAction.reload(filter))
                }
                .onChange(of: selection) { _ in
                    dismiss()
                }
        }
    }
}
