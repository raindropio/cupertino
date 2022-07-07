enum SettingsPage: Hashable {
    case account
    case pro
    case `import`
    
    var title: String {
        switch self {
        case .account: return "Account"
        case .pro: return "Pro"
        case .import: return "Import"
        }
    }
    
    var systemImage: String {
        switch self {
        case .account: return "person.crop.circle"
        case .pro: return "dollarsign.circle.fill"
        case .import: return "square.and.arrow.down"
        }
    }
}
