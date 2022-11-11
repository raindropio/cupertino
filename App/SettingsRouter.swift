import SwiftUI

class SettingsRouter: ObservableObject {
    @Published var isPresented = false
    @Published var path: [SettingsRoute] = []
    
    func open(_ route: SettingsRoute? = nil) {
        isPresented = true
        if let route {
            path = [route]
        }
    }
}

enum SettingsRoute {
    case about
}
