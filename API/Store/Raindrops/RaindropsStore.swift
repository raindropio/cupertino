import Foundation

public class RaindropsStore: ReduxStore {
    public var redux: Redux<RaindropsState, RaindropsAction>
    var rest = Rest()
    
    @MainActor public init() {
        redux = .init(initialState: .init())
        redux.delegate = self
    }
}

//MARK: - Catch all actions
extension RaindropsStore {
    public func react(to action: ReduxAction) async throws {
        switch action {
        case is RaindropsAction:
            try await react(to: action as! RaindropsAction)
            
        case is AuthAction:
            try await react(to: action as! AuthAction)
            
        default: break
        }
    }
}

//MARK: - Store specific actions
extension RaindropsStore {
    public func react(to action: RaindropsAction) async throws {
        switch action {
        case .reload(let find, let sort):
            try await reload(find: find, sort: sort)
            
        case .loadMore(let find, let sort):
            try await loadMore(find: find, sort: sort)
            
        case .create(let item):
            redux.dispatch(RaindropsAction.createMany([item]))
            
        case .createMany(let items):
            try await createMany(items: items)
        }
    }
}

//MARK: - Auth specific actions
extension RaindropsStore {
    public func react(to action: AuthAction) async throws {
        switch action {
        case .logout:
            try await logout()
            
        default:
            break
        }
    }
}
