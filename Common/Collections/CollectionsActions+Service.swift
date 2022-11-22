import SwiftUI
import API

class CollectionActionsStore: ObservableObject {
    @Published var ask: Ask?

    func callAsFunction(_ ask: Ask?) {
        if ask == nil, self.ask == nil {
            return
        }
        
        self.ask = ask
    }
}

extension CollectionActionsStore {
    enum Ask {
        case create(CreateCollectionStack.Location = .group())
        case edit(UserCollection)
        case delete(UserCollection)
    }
}
