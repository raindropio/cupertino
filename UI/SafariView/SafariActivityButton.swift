public struct SafariActivityButton {
    public var extensionIdentifier: String
    public var systemImage: String
    
    public init(id: String, systemImage: String) {
        self.extensionIdentifier = id
        self.systemImage = systemImage
    }
}
