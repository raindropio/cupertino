struct SettingsPath {
    var screen: Screen?
}

extension SettingsPath: Identifiable {
    var id: Screen? { screen }
}

extension SettingsPath {
    enum Screen {
        case account
        case subscription
        case backups
        case `import`
        #if canImport(UIKit)
        case appIcon
        #endif
        case extensions
    }
}
