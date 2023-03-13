import SwiftUI
import API

public struct RaindropTags: View {
    @Binding var raindrop: Raindrop
    
    public init(_ raindrop: Binding<Raindrop>) {
        self._raindrop = raindrop
    }
    
    public var body: some View {
        TagsList($raindrop.tags)
            .navigationTitle("\(raindrop.tags.count) tags")
            #if canImport(UIKit)
            .navigationBarTitleDisplayMode(.inline)
            #endif
    }
}
