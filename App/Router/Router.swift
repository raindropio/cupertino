import SwiftUI
import Combine

class Router: ObservableObject {
    @Published var path = [Route]()
    @Published var sidebar: Route? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $sidebar
            .sink { [weak self] _ in
                self?.path = .init()
            }
            .store(in: &cancellables)
    }
    
    func handleDeepLink(_ url: URL) {
        
    }
}
