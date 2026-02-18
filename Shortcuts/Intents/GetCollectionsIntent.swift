import AppIntents
import API

struct GetCollectionsIntent: AppIntent {
    static var title: LocalizedStringResource = "Get Collections"
    static var description: IntentDescription = .init("List all Raindrop.io collections", categoryName: "Collections")
    static var openAppWhenRun = false

    func perform() async throws -> some ReturnsValue<[CollectionEntity]> {
        let collections = try await IntentService.shared.perform { rest in
            let (system, user) = try await rest.collectionsGet()
            return CollectionQuery.ordered(system: system, user: user)
        }
        return .result(value: collections)
    }
}
