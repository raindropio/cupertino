import Foundation

public struct RaindropsState {
    public var count = 0
}

extension RaindropsState: State { static let reducer: Reducer = { state, action in
    switch action {
    case .reset:
        state = .init()
        
    case .raindrops(let make):
        switch make {
        case .load(let find):
            return .raindrops(.fetch(find))
            
        case .fetch(_):
            state.count = state.count + 1
            
        case .create(_):
            throw NSError(domain: "my error domain", code: 42, userInfo: ["ui1":12, "ui2":"val2"] )
            
        default: break
        }
        
    default: break
    }
    
    return nil
}}
