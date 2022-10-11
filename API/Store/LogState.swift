import Foundation

struct LogState {
}

extension LogState: State {
    static let reducer: Reducer<Store.Action> = { state, action in
        print("Store Action:", action)
        return nil
    }
}
