import SwiftUI
import API
import Backport
import UI

extension FiltersEditMode {
    struct Process: View {
        @EnvironmentObject private var dispatch: Dispatcher
        @Environment(\.dismiss) private var dismiss
        var action: Action
    }
}

extension FiltersEditMode.Process {
    var body: some View {
        Backport.NavigationStack {
            Group {
                switch action {
                case .rename(let filter):
                    Rename(filter: filter)
                case .merge(let selection):
                    Merge(selection: selection)
                case .delete(let selection):
                    Delete(selection: selection)
                }
            }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", action: dismiss.callAsFunction)
                    }
                }
        }
            .backport.presentationDetents([.height(240)])
            .backport.presentationDragIndicator(.hidden)
    }
}

extension FiltersEditMode.Process {
    struct Rename: View {
        @Environment(\.dismiss) private var dismiss
        @EnvironmentObject private var dispatch: Dispatcher
        @State private var newName: String = ""
        
        var filter: Filter
        
        private func submit() async throws {
            guard !newName.isEmpty else { return }
            try await dispatch(FiltersAction.update([filter], newName: newName))
            dismiss()
        }
        
        var body: some View {
            Form {
                Section {
                    TextField("New name", text: $newName)
                        .autoFocus()
                }
                
                SubmitButton("Rename")
                    .disabled(newName.isEmpty)
            }
                .navigationTitle("New name")
                .onSubmit(submit)
                .onAppear {
                    newName = filter.title
                }
        }
    }
}

extension FiltersEditMode.Process {
    struct Merge: View {
        @Environment(\.dismiss) private var dismiss
        @EnvironmentObject private var dispatch: Dispatcher
        @State private var newName: String = ""
        
        var selection: Set<Filter>
        
        private func submit() async throws {
            guard !newName.isEmpty else { return }
            try await dispatch(FiltersAction.update(selection, newName: newName))
            dismiss()
        }
        
        var body: some View {
            Form {
                Section {
                    TextField("New name", text: $newName)
                        .autoFocus()
                }
                
                SubmitButton("Merge \(selection.count) tags")
                    .disabled(newName.isEmpty)
            }
                .navigationTitle("New name")
                .onSubmit(submit)
                .onAppear {
                    newName = selection.first?.title ?? ""
                }
        }
    }
}

extension FiltersEditMode.Process {
    struct Delete: View {
        @Environment(\.dismiss) private var dismiss
        @EnvironmentObject private var dispatch: Dispatcher
        var selection: Set<Filter>
        
        @Sendable
        private func delete() async {
            guard !selection.isEmpty else { return }
            try? await dispatch(FiltersAction.delete(selection))
            dismiss()
        }
        
        var body: some View {
            ProgressView()
                .interactiveDismissDisabled()
                .task(id: selection, delete)
        }
    }
}
