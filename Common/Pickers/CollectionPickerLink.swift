import SwiftUI
import API
import Backport

func CollectionPickerLink(_ selection: Binding<Int?>, system: [Int] = []) -> some View {
    NavigationLink {
        CollectionPicker(selection, system: system)
            .modifier(_Screen(selection: selection.wrappedValue))
    } label: {
        _Label(selection: selection.wrappedValue)
    }
}

func CollectionPickerLink(_ selection: Binding<Int>, system: [Int] = []) -> some View {
    NavigationLink {
        CollectionPicker(selection, system: system)
            .modifier(_Screen(selection: selection.wrappedValue))
    } label: {
        _Label(selection: selection.wrappedValue)
    }
}

fileprivate struct _Label: View {
    @EnvironmentObject private var c: CollectionsStore
    var selection: Int?
    
    var body: some View {
        if let selection, let collection = c.state.user[selection] {
            UserCollectionRow(collection, withLocation: true)
                .badge(0)
        } else if let selection, let collection = c.state.system[selection] {
            SystemCollectionRow(collection)
                .badge(0)
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
