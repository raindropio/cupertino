import Foundation

public struct UsersState {
    var some = ""
}

extension UsersState: State {
    static let reducer: Reducer = { state, action in
        return nil
    }
}
