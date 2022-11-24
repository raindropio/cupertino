import Foundation

extension RaindropsReducer {
    func add(state: inout S, url: URL, collection: Int?) async throws -> ReduxAction? {
        var raindrop = try await rest.importUrlParse(url)
        raindrop.collection = collection ?? -1
        return A.create(raindrop)
    }
}
