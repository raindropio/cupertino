import SwiftUI

extension RaindropsReducer {
    func find(state: inout S, raindrop: Binding<Raindrop>) async throws {
        let found = try await rest.raindropFind(link: raindrop.wrappedValue.link)
        if let found {
            raindrop.wrappedValue = found
        }
    }
}
