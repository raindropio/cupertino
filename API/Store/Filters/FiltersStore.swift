import Foundation

public class FiltersStore: ReduxStore {
    public var redux: Redux<FiltersState, FiltersAction>
    var rest = Rest()
    
    @MainActor public init() {
        redux = .init(initialState: .init())
        redux.delegate = self
    }
}

//MARK: - Catch all actions
extension FiltersStore {
    public func react(to action: ReduxAction) async throws {
        if let action = action as? FiltersAction {
            try await react(to: action)
        }
    }
}

//MARK: - Store specific actions
extension FiltersStore {
    public func react(to action: FiltersAction) async throws {
        switch action {
        case .reload(let find):
            try await reload(find: find)
        }
    }
}
