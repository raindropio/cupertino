public struct Tag: Identifiable, Hashable {
    public var id: String {
        name
    }
    public var name: String
    
    public var systemImage: String {
        "number"
    }
}
