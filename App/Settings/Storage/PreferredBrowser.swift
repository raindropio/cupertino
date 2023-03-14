enum PreferredBrowser: String, CaseIterable {
    case inapp
    #if canImport(UIKit)
    case safari
    #endif
    case system
    
    static var `default`: Self {
        .inapp
    }
    
    var title: String {
        switch self {
        case .inapp: return "In app"
        #if canImport(UIKit)
        case .safari: return "Safari"
        #endif
        case .system: return "System default"
        }
    }
}
