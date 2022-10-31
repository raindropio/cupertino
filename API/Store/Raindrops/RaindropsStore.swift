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
        if let action = action as? RaindropsAction {
            try await raindrops(action)
        } else if let action = action as? AuthAction {
            try await auth(action)
        }
    }
}

//MARK: - Store specific actions
extension RaindropsStore {
    private func raindrops(_ action: RaindropsAction) async throws {
        switch action {
        case .reload(let find):
            try await reload(find: find)
            
        case .loadMore(let find):
            try await loadMore(find: find)
            
        case .sort(let find, let by):
            try await sort(find: find, by: by)
            
        case .create(let item):
            redux.dispatch(RaindropsAction.createMany([item]))
            
        case .createMany(let items):
            try await createMany(items: items)
        }
    }
}

//MARK: - Auth specific actions
extension RaindropsStore {
    private func auth(_ action: AuthAction) async throws {
        switch action {
        case .logout:
            try await logout()
            
        default:
            break
        }
    }
}
