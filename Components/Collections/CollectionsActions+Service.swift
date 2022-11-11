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
        case create(Location = .group())
        case edit(UserCollection)
        case delete(UserCollection)
        
        enum Location: Identifiable {
            case group(CGroup? = nil)
            case parent(UserCollection.ID)
            
            var id: String {
                switch self {
                case .group(let group): return group?.title ?? ""
                case .parent(let parentId): return "\(parentId)"
                }
            }
        }
    }
}
