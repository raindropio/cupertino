public struct Tag: Identifiable, Hashable {
    public var id: String
    
    public var systemImage: String {
        "number"
    }
}

//MARK: - Preview
public extension Tag {
    static var preview = [
        Tag(id: "angular"),
        Tag(id: "design"),
        Tag(id: "ui")
    ]
}
