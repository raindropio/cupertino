import Foundation

extension RaindropsState: State { static let reducer: Reducer<Store.Action> = { state, action in
    switch action {
    case .reset:
        state = .init()
        
    case .raindrop(let action):
        switch action {
        case .create(let raindrop):
            return try await effect(&state, .create([raindrop]))
        }
        
    case .raindrops(let action):
        return try await effect(&state, action)
        
    default: break
    }; return nil
}}
