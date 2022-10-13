import Foundation

public enum SomeAction: ReduxAction {
    case hello
}

public class SomeStore: ReduxStore {
    public var redux: Redux<Int, SomeAction>
    
    @MainActor public init() {
        redux = .init(initialState: 0)
        redux.delegate = self
    }
    
    public func react(to action: ReduxAction) async throws {
        await redux.mutate {
            $0 = $0 + 1
        }
    }
}
