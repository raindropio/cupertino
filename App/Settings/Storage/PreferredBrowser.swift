enum PreferredBrowser: String, CaseIterable {
    case inapp
    #if os(iOS)
    case safari
    #endif
    case system
    
    static var `default`: Self {
        .inapp
    }
    
    var title: String {
        switch self {
        case .inapp: return "In app"
        #if os(iOS)
        case .safari: return "Safari"
        #endif
        case .system: return "System default"
        }
    }
}
