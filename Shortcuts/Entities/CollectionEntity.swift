import AppIntents
import API

struct CollectionEntity: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Collection"
    static var defaultQuery = CollectionQuery()

    var id: Int

    @Property(title: "Title") var title: String
    @Property(title: "Count") var count: Int

    private var systemImage: String
    private var path: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(path)",
            subtitle: "\(count) items",
            image: .init(systemName: systemImage)
        )
    }

    init(from collection: some CollectionType, path: String? = nil) {
        self.id = collection.id
        self.systemImage = collection.systemImage
        self.path = path ?? collection.title
        self.title = collection.title
        self.count = collection.count
    }
}
