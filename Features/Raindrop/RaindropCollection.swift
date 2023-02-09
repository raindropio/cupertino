import SwiftUI
import API

public struct RaindropCollection: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.isEnabled) private var isEnabled
    
    @Binding var raindrop: Raindrop
    
    public init(_ raindrop: Binding<Raindrop>) {
        self._raindrop = raindrop
    }
    
    public var body: some View {
        CollectionsList($raindrop.collection, system: [-1, -99])
            .collectionsEvent()
            .navigationTitle("Collection")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: raindrop.collection) { _ in
                guard isEnabled else { return }
                dismiss()
            }
    }
}
