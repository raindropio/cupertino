import SwiftUI
import UI
import UniformTypeIdentifiers

struct AddURL: View {
    @Environment(\.dismiss) private var dismiss
    @State private var url: URL?
    
    var action: ([NSItemProvider]) -> Void

    private func saveUrl() {
        if let url {
            dismiss()
            action([.init(item: url as NSURL, typeIdentifier: UTType.url.identifier)])
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    URLField("https://", value: $url)
                        .autoFocus()
                }
                
                SubmitButton("Save")
                    .disabled(url == nil)
            }
                .onSubmit(saveUrl)
                .navigationTitle("Add link")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", action: dismiss.callAsFunction)
                    }
                }
        }
            .presentationDetents([.height(224)])
            .frame(idealWidth: 400, idealHeight: 200)
    }
}
