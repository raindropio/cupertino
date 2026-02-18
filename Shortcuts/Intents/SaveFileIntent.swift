import AppIntents
import UniformTypeIdentifiers
import API

@available(iOS 18, macOS 15, *)
struct SaveFileIntent: AppIntent {
    static var title: LocalizedStringResource = "Save File"
    static var description: IntentDescription = .init("Upload a file to Raindrop.io", categoryName: "Bookmarks")
    static var openAppWhenRun = false

    @Parameter(title: "File", supportedContentTypes: [.image, .video, .movie, .audio, .pdf, .epub], inputConnectionBehavior: .connectToPreviousIntentResult)
    var file: IntentFile

    @Parameter(title: "Title", requestValueDialog: "Title (optional, auto-detected from file)")
    var title: String?

    @Parameter(title: "Collection")
    var collection: CollectionEntity?

    @Parameter(title: "Tags")
    var tags: [String]?

    @Parameter(title: "Note")
    var note: String?

    static var parameterSummary: some ParameterSummary {
        Summary("Save \(\.$file) to Raindrop.io") {
            \.$title
            \.$collection
            \.$tags
            \.$note
        }
    }

    func perform() async throws -> some ReturnsValue<BookmarkEntity> {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(file.filename)
        try file.data.write(to: url)
        defer { try? FileManager.default.removeItem(at: url) }

        let created = try await IntentService.shared.perform { rest in
            let original = try await rest.raindropUploadFile(file: url, collection: collection?.id)

            let needsUpdate = (title != nil && !title!.isEmpty) || (tags != nil && !tags!.isEmpty) || (note != nil && !note!.isEmpty)
            guard needsUpdate else { return original }

            var modified = original
            if let title, !title.isEmpty { modified.title = title }
            if let tags, !tags.isEmpty { modified.tags = tags }
            if let note, !note.isEmpty { modified.note = note }
            return try await rest.raindropUpdate(original: original, modified: modified)
        }
        return .result(value: BookmarkEntity(from: created))
    }
}
