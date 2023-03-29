import SwiftUI
import API
import Features
import Backport

struct SaveFiles: View {
    @Environment(\.dismiss) private var dismiss
    
    var urls: Set<URL>
    @State var collection: Int?
    
    var body: some View {
        Group {
            if let collection {
                AddStack(urls, to: collection)
                    .presentationDetents([.fraction(0.333)])
                    .backport.presentationBackground(.regularMaterial)
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
