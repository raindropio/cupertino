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
        NavigationView {
            Group {
                switch action {
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
    struct Merge: View {
        @State private var newName: String = ""
        var selection: Set<Filter>
        
        var body: some View {
            Form {
                Section {
                    TextField("New name", text: $newName)
                        .autoFocus()
                }
                
                SubmitButton("Merge \(selection.count) tags")
            }
                .navigationTitle("New name")
                .onAppear {
                    newName = selection.first?.title ?? ""
                }
        }
    }
}

extension FiltersEditMode.Process {
    struct Delete: View {
        var selection: Set<Filter>
        
        var body: some View {
            ProgressView()
                .interactiveDismissDisabled()
        }
    }
}
