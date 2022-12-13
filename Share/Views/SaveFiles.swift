import SwiftUI
import API
import Common

struct SaveFiles: View {
    @Environment(\.dismiss) private var dismiss
    @State private var collection: Int?
    var urls: Set<URL>
    
    var body: some View {
        Group {
            if let collection {
                AddStack(urls, to: collection)
                    .backport.presentationDetents([.medium])
            } else {
                NavigationView {
                    CollectionsList(selection: $collection, matching: .insertable, searchable: true)
                        .collectionActions()
                        .navigationTitle("Where to save")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel", role: .cancel, action: dismiss.callAsFunction)
                            }
                        }
                }
            }
        }
            .transition(.opacity)
            .animation(.default, value: collection)
    }
}
