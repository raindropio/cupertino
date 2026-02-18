import AppIntents
import API

@available(iOS 18, macOS 15, *)
struct AddBookmarkIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Bookmark"
    static var description: IntentDescription = .init("Save a URL to Raindrop.io", categoryName: "Bookmarks")
    static var openAppWhenRun = false

    @Parameter(title: "URL")
    var url: URL

    @Parameter(title: "Title", requestValueDialog: "Title (optional, auto-detected from page)")
    var title: String?

    @Parameter(title: "Note")
    var note: String?

    @Parameter(title: "Collection")
    var collection: CollectionEntity?

    @Parameter(title: "Tags")
    var tags: [String]?

    @Parameter(title: "Favorite")
    var important: Bool?

    static var parameterSummary: some ParameterSummary {
        Summary("Add \(\.$url) to Raindrop.io") {
            \.$title
            \.$collection
            \.$tags
            \.$important
            \.$note
        }
    }

    func perform() async throws -> some ReturnsValue<BookmarkEntity> {
        let created = try await IntentService.shared.perform { rest in
            var raindrop = Raindrop.new(link: url, collection: collection?.id)
            if let title, !title.isEmpty { raindrop.title = title }
            if let tags, !tags.isEmpty { raindrop.tags = tags }
            if let important { raindrop.important = important }
            if let note, !note.isEmpty { raindrop.note = note }
            return try await rest.raindropCreate(raindrop: raindrop)
        }
        return .result(value: BookmarkEntity(from: created))
    }
}
