import SwiftUI
import UI
import API

struct IconPicker: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var icons: IconsStore
    @EnvironmentObject private var dispatch: Dispatcher
    @Binding var selection: URL?
    @SceneStorage("select-icon-filter") private var filter = ""
    
    var searchPlacement: SearchFieldPlacement {
        #if os(iOS)
        .navigationBarDrawer(displayMode: .always)
        #else
        .automatic
        #endif
    }
    
    var body: some View {
        ImagePicker(
            icons.state.filtered(filter),
            selection: $selection,
            width: 48, height: 48
        )
            .equatable()
            .navigationTitle("Select icon")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .searchable(text: $filter, debounce: 0.5, placement: searchPlacement)
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button("Reset") {
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
