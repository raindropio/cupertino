import SwiftUI
import API

class AppRouter: ObservableObject {
    @Published var find: FindBy? = .init()
    @Published var spotlight = false
    @Published var preview: URL?
}
