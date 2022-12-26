import SwiftUI
import API
import Common
import Backport

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
                Backport.NavigationStack {
                    CollectionPicker($collection, system: [-1])
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
