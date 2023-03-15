import SwiftUI
import API
import Features

struct SaveFiles: View {
    @Environment(\.dismiss) private var dismiss
    
    var urls: Set<URL>
    @State var collection: Int?
    
    var body: some View {
        Group {
            if let collection {
                AddStack(urls, to: collection)
                    .presentationDetents([.medium])
            } else {
                NavigationStack {
                    CollectionsList($collection, system: [-1])
                        .collectionSheets()
                        .navigationTitle("Where to save")
                        #if canImport(UIKit)
                        .navigationBarTitleDisplayMode(.inline)
                        #endif
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
