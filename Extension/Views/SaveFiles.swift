import SwiftUI
import API
import UI
import Features
import Backport

struct SaveFiles: View {
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
                            CancelToolbarItem()
                        }
                }
            }
        }
            .transition(.opacity)
            .animation(.default, value: collection)
    }
}
