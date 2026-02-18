import AppIntents
import API

struct RemoveTagsFromBookmarksIntent: AppIntent {
    static var title: LocalizedStringResource = "Remove Tags from Bookmarks"
    static var description: IntentDescription = .init("Remove tags from one or more bookmarks", categoryName: "Bookmarks")
    static var openAppWhenRun = false

    @Parameter(title: "Bookmarks")
    var bookmarks: [BookmarkEntity]

    @Parameter(title: "Tags")
    var tags: [String]

    static var parameterSummary: some ParameterSummary {
        Summary("Remove \(\.$tags) from \(\.$bookmarks)")
    }

    func perform() async throws -> some IntentResult {
        try await IntentService.shared.perform { rest in
            let ids = Set(bookmarks.map(\.id))
            _ = try await rest.raindropsUpdate(pick: .some(ids), operation: .deleteTags(tags))
        }
        return .result()
    }
}
