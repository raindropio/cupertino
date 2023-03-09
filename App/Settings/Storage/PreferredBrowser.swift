enum PreferredBrowser: String, CaseIterable {
    case inapp
    case safari
    case system
    
    static var `default`: Self {
        .inapp
    }
    
    var title: String {
        switch self {
        case .inapp: return "In app"
        case .safari: return "Safari"
        case .system: return "System default"
        }
    }
}
