import SwiftUI
import API
import UI
import Backport

struct TagRenameStack: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var newName: String = ""
    
    var tag: String
    
    private func submit() async throws {
        guard !newName.isEmpty else { return }
        try await dispatch(FiltersAction.update([.init(.tag(tag))], newName: newName))
        dismiss()
    }
    
    var body: some View {
        Backport.NavigationStack {
            Form {
                Section {
                    TextField("New name", text: $newName)
                        .autoFocus()
                }
                
                SubmitButton("Rename")
                    .disabled(newName.isEmpty)
            }
                .navigationTitle("New name")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", action: dismiss.callAsFunction)
                    }
                }
                .onSubmit(submit)
                .onAppear {
                    newName = tag
                }
        }
            .backport.presentationDetents([.height(240)])
            .backport.presentationDragIndicator(.hidden)
    }
}
