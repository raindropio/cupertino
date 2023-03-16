import SwiftUI
import UI
import UniformTypeIdentifiers
import Backport

struct AddURL: View {
    @Environment(\.dismiss) private var dismiss
    @State private var url: URL?
    @FocusState private var focused
    
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
                    URLField("", value: $url, prompt: Text("https://"))
                        .backport.focused($focused)
                }
                
                SubmitButton("Save")
                    .disabled(url == nil)
            }
                .labelsHidden()
                .backport.defaultFocus($focused, true)
                .onSubmit(saveUrl)
                #if canImport(UIKit)
                .navigationTitle("Add link")
                .navigationBarTitleDisplayMode(.inline)
                #else
                .controlSize(.large)
                .textFieldStyle(.roundedBorder)
                #endif
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
