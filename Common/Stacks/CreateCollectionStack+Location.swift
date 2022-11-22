import API

extension CreateCollectionStack {
    public enum Location: Identifiable {
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
