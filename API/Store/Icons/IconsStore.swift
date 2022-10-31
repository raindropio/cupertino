import Foundation

public class IconsStore: ReduxStore {
    public var redux: Redux<IconsState, IconsAction>
    var rest = Rest()
    
    @MainActor public init() {
        redux = .init(initialState: .init())
        redux.delegate = self
    }
}

//MARK: - Catch all actions
extension IconsStore {
    public func react(to action: ReduxAction) async throws {
        if let action = action as? IconsAction {
            try await icons(action)
        }
    }
}

//MARK: - Store specific actions
extension IconsStore {
    private func icons(_ action: IconsAction) async throws {
        switch action {
        case .reload(let filter):
            try await reload(filter: filter)
        }
    }
}
