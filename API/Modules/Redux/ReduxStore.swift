import Foundation
import Combine

public protocol ReduxStore: ObservableObject where Self.ObjectWillChangePublisher == ObservableObjectPublisher {
    associatedtype State: Equatable
    associatedtype Action: ReduxAction
    var redux: Redux<State, Action> { get }
    
    func react(to action: ReduxAction) async throws
    func react(to error: Error) async
}

//helpers
extension ReduxStore {
    //read-only state
    @MainActor public var state: State {
        redux.state
    }
    
    //ability to dispatch any action
    public func dispatch(_ action: ReduxAction) {
        redux.dispatch(action)
    }
    
    //ability to easly dispatch store specific actions
    public func dispatch(_ action: Action) {
        redux.dispatch(action)
    }
    
    //wait for some condition
    public func wait(for condition: (State)->Bool) async {
        await redux.wait(for: condition)
    }
    
    //mutate variable
    func mutate(_ perform: (_ state: inout State) async throws -> Void) async throws {
        try await redux.mutate(perform)
    }
}

//default implementation
extension ReduxStore {
    public func react(to action: ReduxAction) async throws {}
    public func react(to error: Error) async {}
}
