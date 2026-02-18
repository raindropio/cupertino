import AppIntents
import API

struct UnmarkBookmarksAsFavoriteIntent: AppIntent {
    static var title: LocalizedStringResource = "Unmark Bookmarks as Favorite"
    static var description: IntentDescription = .init("Remove favorite status from one or more bookmarks", categoryName: "Bookmarks")
    static var openAppWhenRun = false

    @Parameter(title: "Bookmarks")
    var bookmarks: [BookmarkEntity]

    static var parameterSummary: some ParameterSummary {
        Summary("Unmark \(\.$bookmarks) as favorite")
    }

    func perform() async throws -> some IntentResult {
        try await IntentService.shared.perform { rest in
            let ids = Set(bookmarks.map(\.id))
            _ = try await rest.raindropsUpdate(pick: .some(ids), operation: .important(false))
        }
        return .result()
    }
}
