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
        case .inapp: return "Raindrop.io"
        #if os(iOS)
        case .safari: return "Safari"
        #endif
        case .system: return "Default System Browser"
        }
    }
    
    var description: String {
        switch self {
        case .inapp: return "Clean, reader-friendly view with option to highlight content"
        #if os(iOS)
        case .safari: return "Open links in Safari without leaving the app"
        #endif
        case .system: return "Your device’s default browser"
        }
    }
    
    var systemImage: String {
        switch self {
        case .inapp: return "cloud"
        #if os(iOS)
        case .safari: return "safari"
        #endif
        case .system: return "arrow.up.forward"
        }
    }
    
    static let key = "browser"
}
