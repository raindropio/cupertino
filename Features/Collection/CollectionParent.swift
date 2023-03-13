import SwiftUI
import API

public struct CollectionParent: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.isEnabled) private var isEnabled
    
    @Binding var collection: UserCollection
    
    public init(_ collection: Binding<UserCollection>) {
        self._collection = collection
    }
    
    public var body: some View {
        CollectionsList($collection.parent)
            .collectionSheets()
            .navigationTitle("Parent")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                if collection.parent != nil {
                    ToolbarItem {
                        Button("None") {
                            collection.parent = nil
                        }
                    }
                }
            }
            .onChange(of: collection.parent) { _ in
                guard isEnabled else { return }
                dismiss()
            }
    }
}
