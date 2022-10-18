import Foundation

public enum ErrorAction: ReduxAction {}

public class ErrorStore: ReduxStore {
    public var redux: Redux<Int, ErrorAction>
    var rest = Rest()
    
    @MainActor public init() {
        redux = .init(initialState: 0)
        redux.delegate = self
    }
}

//MARK: - Catch all errors
extension FiltersStore {
    public func react(to error: Error) async {
        print(error)
    }
}
