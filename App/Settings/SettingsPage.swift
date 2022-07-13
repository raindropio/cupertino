import Foundation

enum SettingsPage: String, Hashable, Identifiable {
    case index
    case general
    case account
    case subscription
    case `import`
    case backups
    case about
    
    var id: String {
        self.rawValue
    }
    
    var label: String {
        switch self {
        case .index:        return ""
        case .general:      return "General"
        case .account:      return "Account"
        case .subscription: return "Subscription"
        case .import:       return "Import"
        case .backups:      return "Backups"
        case .about:        return "About"
        }
    }
    
    var systemImage: String {
        switch self {
        case .index:        return ""
        case .general:      return "gear"
        case .account:      return "person.crop.circle"
        case .subscription: return "trophy"
        case .import:       return "square.and.arrow.down"
        case .backups:      return "arrow.clockwise.icloud"
        case .about:        return "cloud"
        }
    }
}
