import Foundation

public class RaindropStore: ReduxStore {
    public var redux: Redux<RaindropState, RaindropAction>
    var rest = Rest()
    
    @MainActor public init() {
        redux = .init(initialState: .init())
        redux.delegate = self
    }
}

//MARK: - Catch all actions
extension RaindropStore {
    public func react(to action: ReduxAction) async throws {
        if let action = action as? RaindropAction {
            try await react(to: action)
        }
    }
}

//MARK: - Store specific actions
extension RaindropStore {
    public func react(to action: RaindropAction) async throws {
        switch action {
        case .reload(let find, let sort):
            try await reload(find: find, sort: sort)
            
        case .loadMore(let find, let sort):
            try await loadMore(find: find, sort: sort)
            
        case .create(let item):
            redux.dispatch(RaindropAction.createMany([item]))
            
        case .createMany(let items):
            try await createMany(items: items)
        }
    }
}
