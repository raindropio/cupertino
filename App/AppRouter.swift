import SwiftUI
import API
import UI

class AppRouter: ObservableObject {
    @Published var find: FindBy? = .init()
    @Published var path: NavigationPath = .init()
    @Published var spotlight = false
    
    func browse(_ id: Raindrop.ID, mode: Browse.Location.Mode? = nil) {
        path.append(Browse.Location(kind: .raindrop(id), mode: mode))
    }
    
    func browse(_ url: URL, mode: Browse.Location.Mode? = nil) {
        path.append(Browse.Location(kind: .url(url), mode: mode))
    }
}
