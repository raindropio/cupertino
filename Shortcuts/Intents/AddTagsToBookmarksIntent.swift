import AppIntents
import API

struct AddTagsToBookmarksIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Tags to Bookmarks"
    static var description: IntentDescription = .init("Add tags to one or more bookmarks", categoryName: "Bookmarks")
    static var openAppWhenRun = false

    @Parameter(title: "Bookmarks")
    var bookmarks: [BookmarkEntity]

    @Parameter(title: "Tags")
    var tags: [String]

    static var parameterSummary: some ParameterSummary {
        Summary("Add \(\.$tags) to \(\.$bookmarks)")
    }

    func perform() async throws -> some IntentResult {
        try await IntentService.shared.perform { rest in
            let ids = Set(bookmarks.map(\.id))
            _ = try await rest.raindropsUpdate(pick: .some(ids), operation: .addTags(tags))
        }
        return .result()
    }
}
