import AppIntents
import API

struct BookmarkEntity: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Bookmark"
    static var defaultQuery = BookmarkQuery()

    var id: Int

    @Property(title: "Title")         var title: String
    @Property(title: "URL")           var link: URL
    @Property(title: "Note")          var note: String
    @Property(title: "Tags")          var tags: [String]
    @Property(title: "Collection ID") var collectionId: Int
    @Property(title: "Favorite")      var important: Bool
    @Property(title: "Created")       var created: Date

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)",
            subtitle: "\(link.host ?? link.absoluteString)"
        )
    }

    init(from raindrop: Raindrop) {
        self.id = raindrop.id
        self.title = raindrop.title
        self.link = raindrop.link
        self.note = raindrop.note
        self.tags = raindrop.tags
        self.collectionId = raindrop.collection
        self.important = raindrop.important
        self.created = raindrop.created
    }
}
