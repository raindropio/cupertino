import SwiftUI
import API
import Features

struct SaveFiles: View {
    @Environment(\.dismiss) private var dismiss
    @State private var collection: Int?
    var urls: Set<URL>
    
    var body: some View {
        Group {
            if let collection {
                AddStack(urls, to: collection)
                    .presentationDetents([.medium])
            } else {
                NavigationStack {
                    CollectionsList($collection, system: [-1])
                        .collectionsEvent()
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
