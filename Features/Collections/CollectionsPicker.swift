import SwiftUI
import API

func CollectionsPicker(_ selection: Binding<Int?>, system: [Int] = []) -> some View {
    NavigationLink {
        CollectionsList(selection, system: system)
            .collectionSheets()
            .modifier(_Screen(selection: selection.wrappedValue))
    } label: {
        _Label(selection: selection.wrappedValue)
    }
}

func CollectionsPicker(_ selection: Binding<Int>, system: [Int] = []) -> some View {
    NavigationLink {
        CollectionsList(selection, system: system)
            .collectionSheets()
            .modifier(_Screen(selection: selection.wrappedValue))
    } label: {
        _Label(selection: selection.wrappedValue)
    }
}

fileprivate struct _Label: View {
    @EnvironmentObject private var c: CollectionsStore
    var selection: Int?
    
    var body: some View {
        if let selection {
            CollectionLabel(selection, withLocation: true)
        } else {
            Text("None")
                .foregroundStyle(.secondary)
        }
    }
}

fileprivate struct _Screen: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    var selection: Int?

    func body(content: Content) -> some View {
        content
            .navigationTitle("Select collection")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: selection) { _ in
                dismiss()
            }
    }
}
