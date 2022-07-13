import SwiftUI

class SettingsService: ObservableObject {
    @Published var page: SettingsPage? = nil
    
    func handleDeepLink(_ url: URL) {
        page = .index
    }
}
