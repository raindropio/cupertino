enum SettingsPage: Hashable {
    case account
    case `import`
    
    var title: String {
        switch self {
        case .account: return "Account"
        case .import: return "Import"
        }
    }
    
    var systemImage: String {
        switch self {
        case .account: return "person.crop.circle"
        case .import: return "square.and.arrow.down"
        }
    }
}
