import SwiftUI
import API
import Common
import UI
import Backport

struct FiltersEditMode: ViewModifier {
    @EnvironmentObject private var app: AppRouter
    @Environment(\.editMode) private var editMode
    @State private var action: Action?
    
    @Binding var selection: Set<Filter>
    
    @ViewBuilder
    private func selectButton(_ selection: Set<Filter>) -> some View {
        if self.selection != selection {
            Button {
                withAnimation {
                    editMode?.wrappedValue = .active
                    self.selection = selection
                }
            } label: {
                Label("Select", systemImage: "checkmark.circle")
            }
        }
    }
    
    @ViewBuilder
    private func renameButton(_ selection: Set<Filter>) -> some View {
        if selection.count == 1, let filter = selection.first {
            Button {
                action = .rename(filter)
            } label: {
                Label("Rename", systemImage: "pencil")
            }
        }
    }
    
    @ViewBuilder
    private func mergeButton(_ selection: Set<Filter>) -> some View {
        if selection.count > 1 {
            Button {
                action = .merge(selection)
            } label: {
                Label("Merge", systemImage: "arrow.triangle.merge")
            }
        }
    }
    
    @ViewBuilder
    private func deleteButton(_ selection: Set<Filter>) -> some View {
        if !selection.isEmpty {
            Menu {
                Button("Delete \(selection.count) tags", role: .destructive) {
                    action = .delete(selection)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
                .tint(.red)
        }
    }
    
    func body(content: Content) -> some View {
        content
        //context menu
        .backport.contextMenu(forSelectionType: Filter.self) { selected in
            selectButton(selected)
            renameButton(selected)
            mergeButton(selected)
            deleteButton(selected)
        } primaryAction: {
            if let first = $0.first {
                app.browse(first)
            }
        }
        //title
        .background {
            if editMode?.wrappedValue == .active, !selection.isEmpty {
                Color.clear
                    .navigationTitle("Selected \(selection.count) tags")
                    .navigationBarBackButtonHidden()
            }
        }
        //toolbar
        .toolbar {
            ToolbarItem {
                EditButton()
            }
            
            ToolbarItemGroup(placement: .bottomBar) {
                Group {
                    renameButton(selection)
                    mergeButton(selection)
                    deleteButton(selection)
                }
                .labelStyle(.titleOnly)
            }
        }
        //action
        .sheet(item: $action, content: Process.init)
        .environment(\.filtersEditModeAction, $action)
    }
}
