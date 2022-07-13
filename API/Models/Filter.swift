public struct Filter: Identifiable, Hashable {
    public var id: String {
        "\(key):\(value)"
    }
    public var key: String
    public var value: String
    
    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }
    
    public var title: String {
        "\(key) \(value)"
    }
    
    public var systemImage: String {
        "line.3.horizontal.decrease.circle"
    }
}
