import Foundation

public enum DebugAction: ReduxAction {}

public class DebugStore: ReduxStore {
    public var redux: Redux<Int, DebugAction>
    var rest = Rest()
    
    @MainActor public init() {
        redux = .init(initialState: 0)
        redux.delegate = self
    }
}

//MARK: - Catch all errors
extension DebugStore {
    public func react(to action: ReduxAction) async throws {
        print(type(of: action), action)
    }
    
    public func react(to error: Error) async {
        print("Store Error:", error)
    }
}
