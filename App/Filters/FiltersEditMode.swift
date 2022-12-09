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
    
    private var isAction: Bool {
        editMode?.wrappedValue == .active
    }
    
    private var selectedTitle: String {
        "\(selection.count) tags"
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
        Menu {
            Button("Delete \(selectedTitle)", role: .destructive) {
                action = .delete(selection)
            }
        } label: {
            Label("Delete", systemImage: "trash")
        }
            .tint(.red)
    }
    
    func body(content: Content) -> some View {
        content
        //context menu
        .backport.contextMenu(forSelectionType: Filter.self) { selected in
            if !selected.isEmpty {
                if selected != selection {
                    Button {
                        withAnimation {
                            editMode?.wrappedValue = .active
                            selection = selected
                        }
                    } label: {
                        Label("Select", systemImage: "checkmark.circle")
                    }
                }
                
                mergeButton(selected)
                deleteButton(selected)
            }
        } primaryAction: {
            if let first = $0.first {
                app.browse(first)
            }
        }
        //title
        .background {
            if isAction, !selection.isEmpty {
                Color.clear.navigationTitle("Selected \(selectedTitle)")
            }
        }
        //toolbar
        .navigationBarBackButtonHidden(isAction)
        .toolbar {
            ToolbarItem {
                EditButton()
            }
            
            ToolbarItemGroup(placement: .bottomBar) {
                if isAction {
                    Group {
                        mergeButton(selection)
                        deleteButton(selection)
                    }
                    .labelStyle(.titleOnly)
                    .disabled(selection.isEmpty)
                }
            }
        }
        //action
        .sheet(item: $action, content: Process.init)
        .environment(\.filtersEditModeAction, $action)
    }
}
