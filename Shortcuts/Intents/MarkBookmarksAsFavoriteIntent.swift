import AppIntents
import API

struct MarkBookmarksAsFavoriteIntent: AppIntent {
    static var title: LocalizedStringResource = "Mark Bookmarks as Favorite"
    static var description: IntentDescription = .init("Mark one or more bookmarks as favorite", categoryName: "Bookmarks")
    static var openAppWhenRun = false

    @Parameter(title: "Bookmarks")
    var bookmarks: [BookmarkEntity]

    static var parameterSummary: some ParameterSummary {
        Summary("Mark \(\.$bookmarks) as favorite")
    }

    func perform() async throws -> some IntentResult {
        try await IntentService.shared.perform { rest in
            let ids = Set(bookmarks.map(\.id))
            _ = try await rest.raindropsUpdate(pick: .some(ids), operation: .important(true))
        }
        return .result()
    }
}
