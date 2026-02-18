import AppIntents
import API

struct DeleteBookmarksIntent: AppIntent {
    static var title: LocalizedStringResource = "Delete Bookmarks"
    static var description: IntentDescription = .init("Move one or more bookmarks to trash", categoryName: "Bookmarks")
    static var openAppWhenRun = false

    @Parameter(title: "Bookmarks")
    var bookmarks: [BookmarkEntity]

    static var parameterSummary: some ParameterSummary {
        Summary("Delete \(\.$bookmarks)")
    }

    func perform() async throws -> some IntentResult {
        try await requestConfirmation(
            result: .result(dialog: "Are you sure you want to delete \(bookmarks.count) bookmark(s)?")
        )
        try await IntentService.shared.perform { rest in
            let ids = Set(bookmarks.map(\.id))
            _ = try await rest.raindropsDelete(pick: .some(ids))
        }
        return .result()
    }
}
