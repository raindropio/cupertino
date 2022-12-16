import SwiftUI

extension RaindropsReducer {
    func find(state: inout S, raindrop: Binding<Raindrop>) async throws {
        async let findFetch = rest.raindropGet(link: raindrop.wrappedValue.link)
        async let metaFetch = rest.importUrlParse(raindrop.wrappedValue.link)
        
        let (found, meta) = try await (findFetch, metaFetch)
        if let found {
            raindrop.wrappedValue = found
        } else {
            raindrop.wrappedValue.enrich(from: meta)
        }
    }
}
