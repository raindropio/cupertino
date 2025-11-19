enum UniversalLinks: String, CaseIterable {
    case enabled
    case disabled
    
    static var `default`: Self {
        .enabled
    }
    
    static let key = "universal-links"
}
