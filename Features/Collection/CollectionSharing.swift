import SwiftUI
import API
import UI

public struct CollectionSharing: View {
    @Binding var collection: UserCollection
    
    public init(_ collection: Binding<UserCollection>) {
        self._collection = collection
    }
    
    public var body: some View {
        Form {
            PublicPage(collection: $collection)
            Collaboration(collection: $collection)
        }
            .headerProminence(.increased)
            .safeAnimation(.default, value: collection.public)
            .navigationTitle("Sharing")
            #if canImport(UIKit)
            .navigationBarTitleDisplayMode(.inline)
            #endif
    }
}
