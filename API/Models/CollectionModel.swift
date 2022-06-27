public struct Collection: Identifiable, Hashable {
    public var id: Int
    public var title: String
    public var isSystem: Bool { id <= 0 }
    public var children: [Collection]?
}

//MARK: Preview
public extension Collection {
    struct Preview {
        static public var system = [
            Collection(id: 0, title: "All bookmarks"),
            Collection(id: -1, title: "Unsorted"),
        ]
        static public var items = [
            Collection(
                id: 66,
                title: "Design",
                children: [
                    .init(id: 134, title: "Inspiration")
                ]
            ),
            Collection(id: 33, title: "Development")
        ]
    }
}
