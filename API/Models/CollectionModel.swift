public struct Collection: Identifiable, Hashable {
    public var id: Int
    public var title: String
    public var isSystem: Bool { id <= 0 }
}

//MARK: Preview
public extension Collection {
    struct Preview {
        static public var system = [
            Collection(id: 0, title: "All bookmarks"),
            Collection(id: -1, title: "Unsorted"),
        ]
        static public var items = [
            Collection(id: 66, title: "Design"),
            Collection(id: 33, title: "Development")
        ]
    }
}
