import Foundation

struct LogState {
}

extension LogState: State {
    static let reducer: Reducer = { state, action in
        print("Store Action:", action)
        return nil
    }
}
