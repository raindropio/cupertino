import Foundation

extension UserState: State { static let reducer: Reducer<Store.Action> = { state, action in
    switch action {
    case .reset:
        state = .init()
        
    case .user(let action):
        return try await effect(&state, action)
        
    default: break
    }; return nil
}}
