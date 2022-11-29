import API

extension CollectionStack {
    public enum NewLocation: Identifiable {
        case group(CGroup? = nil)
        case parent(UserCollection.ID)
        
        public var id: String {
            switch self {
            case .group(let group): return group?.title ?? ""
            case .parent(let parentId): return "\(parentId)"
            }
        }
    }
}
