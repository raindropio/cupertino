import Foundation

public class Redux<State: Equatable, Action: ReduxAction>: ObservableObject {
    @MainActor @Published var state: State
    var delegate: (any ReduxStore)! = nil
    
    @MainActor init(initialState: State) {
        self.state = initialState
        
        //subscribe to events
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onNotification),
            name: Self.ncName,
            object: nil
        )
    }
    
    deinit {
        //unsubscribe to events
        NotificationCenter.default.removeObserver(self, name: Self.ncName, object: nil)
    }
    
    static var ncName: Notification.Name {
        Notification.Name("store-dispatched-Action")
    }
    
    //react to events
    @objc func onNotification(_ notification: Notification) {
        //action
        if let action = notification.object as? ReduxAction {
            Task {
                do {
                    try await delegate.react(to: action)
                } catch {
                    dispatch(error)
                }
            }
        }
        //error
        else if let error = notification.object as? Error {
            Task {
                await delegate.react(to: error)
            }
        }
    }
    
    //send some event as action
    func dispatch(_ action: ReduxAction) {
        NotificationCenter.default.post(
            name: Self.ncName,
            object: action,
            userInfo: [:]
        )
    }
    
    func dispatch(_ error: Error) {
        NotificationCenter.default.post(
            name: Self.ncName,
            object: error,
            userInfo: [:]
        )
    }
    
    //make sure to mutate state only this way!
    func mutate(_ perform: (_ state: inout State) async throws -> Void) async throws {
        var newState = await state
        
        try await perform(&newState)
        
        guard await state != newState
        else { return }

        await MainActor.run { [newState] in
            state = newState
            delegate.objectWillChange.send()
        }
    }
    
    //wait for condition
    func wait(for condition: (State)->Bool) async {
        var tries = 0
        
        while !(await condition(state)) {
            try? await Task.sleep(nanoseconds: UInt64(1_000_000_000 * 0.1))
            tries += 1
            
            //max 10 seconds
            if tries > 100 {
                break
            }
        }
    }
}
