import AppIntents
import API

struct BookmarkQuery: EntityStringQuery {
    func entities(for identifiers: [Int]) async throws -> [BookmarkEntity] {
        try await IntentService.shared.perform { rest in
            try await rest.raindropsGet(ids: identifiers)
                .map { BookmarkEntity(from: $0) }
        }
    }

    func entities(matching string: String) async throws -> [BookmarkEntity] {
        try await IntentService.shared.perform { rest in
            let find = FindBy(0, text: string)
            let (raindrops, _) = try await rest.raindropsGet(find, sort: .score)
            return raindrops.map { BookmarkEntity(from: $0) }
        }
    }

    func suggestedEntities() async throws -> [BookmarkEntity] {
        try await IntentService.shared.perform { rest in
            let find = FindBy(0)
            let (raindrops, _) = try await rest.raindropsGet(find, sort: .created(.desc))
            return raindrops.map { BookmarkEntity(from: $0) }
        }
    }
}
