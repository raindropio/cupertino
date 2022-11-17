import SwiftUI
import API

public struct EditRaindropScreen: View {
    @State var raindrop: Raindrop
    
    public init(raindrop: Raindrop) {
        self._raindrop = State(initialValue: raindrop)
    }
    
    public var body: some View {
        Form {
            TextField("Title", text: $raindrop.title)
        }
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
    }
}
