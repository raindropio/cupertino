import Foundation

extension RaindropsState { static let effect: Reducer<Store.RaindropsAction> = { state, action in
    switch action {
    //MARK: - Load
    case .load(let find, let sort):
        return .raindrops(.fetch(find, sort))
        
        //MARK: - Fetch
    case .fetch(_, _):
        break
        
        //MARK: - Create
    case .create(_):
        throw NSError(domain: "my error domain", code: 42, userInfo: ["ui1":12, "ui2":"val2"] )
        
    default: break
    }; return nil
}}
