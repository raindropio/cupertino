import SwiftUI
import Combine
import API

class SearchService: ObservableObject {
    @Published var collection: Collection!
    
    @Published var text: String = ""
    @Published var isSearching: Bool = false
    @Published var scope: SearchScope = .everywhere
    @Published var tokens: [SearchToken] = []
    @Published var hideSuggestions = false
    
    private var _cachedQuery: String = ""
    private var origin: Collection?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        //Logic to properly toggle scope
        Publishers.CombineLatest($isSearching, $scope)
            .sink { [weak self] (isSearching, scope) in
                if isSearching {
                    switch scope {
                    case .everywhere:
                        if self?.collection.id != 0 {
                            self?.origin = self?.collection
                            self?.collection = .Preview.system.first!
                        }
                        
                    case .incollection:
                        if let o = self?.origin {
                            self?.collection = o
                            self?.origin = nil
                        }
                    }
                } else if let o = self?.origin {
                    self?.collection = o
                    self?.origin = nil
                }
            }
            .store(in: &cancellables)
    }
    
    func getQuery() -> String {
        text
    }
    
    func setQuery(_ query: String) {
        if _cachedQuery != query {
            _cachedQuery = query
            text = query
            hideSuggestions = false
        }
    }
    
    var secondScope: Collection? {
        if origin != nil || (collection != nil && collection.id != 0) {
            return (origin ?? collection)
        }
        return nil
    }
}
