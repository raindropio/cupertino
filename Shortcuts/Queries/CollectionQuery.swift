import AppIntents
import API

struct CollectionQuery: EntityStringQuery {
    func entities(for identifiers: [Int]) async throws -> [CollectionEntity] {
        try await IntentService.shared.perform { rest in
            let (system, user) = try await rest.collectionsGet()
            let all: [any CollectionType] = system + user
            return identifiers.compactMap { id in
                all.first(where: { $0.id == id }).map { CollectionEntity(from: $0) }
            }
        }
    }

    func entities(matching string: String) async throws -> [CollectionEntity] {
        try await IntentService.shared.perform { rest in
            let (system, user) = try await rest.collectionsGet()
            let lowered = string.lowercased()
            return Self.ordered(system: system, user: user)
                .filter { $0.title.lowercased().contains(lowered) }
        }
    }

    func suggestedEntities() async throws -> [CollectionEntity] {
        try await IntentService.shared.perform { rest in
            let (system, user) = try await rest.collectionsGet()
            return Self.ordered(system: system, user: user)
        }
    }

    static func ordered(system: [SystemCollection], user: [UserCollection]) -> [CollectionEntity] {
        var result: [CollectionEntity] = []

        // Unsorted (-1)
        if let unsorted = system.first(where: { $0.id == -1 }) {
            result.append(CollectionEntity(from: unsorted))
        }

        // Build path for each user collection
        let byId = Dictionary(uniqueKeysWithValues: user.map { ($0.id, $0) })

        func buildPath(for collection: UserCollection) -> String {
            var parts = [collection.title]
            var current = collection
            while let parentId = current.parent, let parent = byId[parentId] {
                parts.insert(parent.title, at: 0)
                current = parent
            }
            return parts.joined(separator: " / ")
        }

        let withPaths = user.map { (collection: $0, path: buildPath(for: $0)) }
            .sorted { $0.path.localizedCaseInsensitiveCompare($1.path) == .orderedAscending }

        result += withPaths.map { CollectionEntity(from: $0.collection, path: $0.path) }

        // Trash (-99)
        if let trash = system.first(where: { $0.id == -99 }) {
            result.append(CollectionEntity(from: trash))
        }

        return result
    }
}
