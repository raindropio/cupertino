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
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: collection.parent) { _ in
                guard isEnabled else { return }
                dismiss()
            }
    }
}
