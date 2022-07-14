public struct Tag: Identifiable, Hashable {
    public var id: String {
        name
    }
    public var name: String
    
    public var systemImage: String {
        "number"
    }
}

//MARK: - Preview
public extension Tag {
    static var preview = [
        Tag(name: "angular"),
        Tag(name: "design"),
        Tag(name: "ui")
    ]
}
