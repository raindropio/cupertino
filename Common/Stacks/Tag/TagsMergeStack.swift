import SwiftUI
import API
import UI
import Backport

struct TagsMergeStack: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var newName: String = ""

    var tags: Set<String>
    
    private func submit() async throws {
        guard !tags.isEmpty else { return }
        try await dispatch(FiltersAction.update(
            .init(
                tags.map {
                    .init(.tag($0))
                }
            ),
            newName: newName
        ))
        dismiss()
    }
    
    var body: some View {
        Backport.NavigationStack {
            Form {
                Section {
                    TextField("New name", text: $newName)
                        .autoFocus()
                }
                
                SubmitButton("Merge \(tags.count) tags")
                    .navigationBarTitleDisplayMode(.inline)
                    .disabled(newName.isEmpty)
            }
                .navigationTitle("New name")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", action: dismiss.callAsFunction)
                    }
                }
                .onSubmit(submit)
                .onAppear {
                    newName = tags.first ?? ""
                }
        }
            .backport.presentationDetents([.height(240)])
            .backport.presentationDragIndicator(.hidden)
    }
}
