import SwiftUI
import API

extension EditRaindropStack {
    public struct ById: View {
        @EnvironmentObject private var r: RaindropsStore
        private var id: Raindrop.ID

        public init(_ id: Raindrop.ID) {
            self.id = id
        }
        
        public var body: some View {
            let raindrop = r.state.item(id)
            
            if let raindrop {
                EditRaindropStack(raindrop)
            }
        }
    }
}
