import SwiftUI
import API

public extension View {
    func raindropCommands(_ pick: RaindropsPick) -> some View {
        modifier(RC(pick: pick))
    }
}

fileprivate struct RC: ViewModifier {
    @EnvironmentObject private var dispatch: Dispatcher
    @EnvironmentObject private var r: RaindropsStore
    var pick: RaindropsPick
    
    private var nothing: Bool {
        switch pick {
        case .all(_): return true
        case .some(let ids): return ids.isEmpty
        }
    }
    
    private var items: [Raindrop] {
        switch pick {
        case .all(let find): return r.state.items(find)
        case .some(let ids): return ids.compactMap(r.state.item)
        }
    }

    func body(content: Content) -> some View {
        let items = items
        
        content
            .copyable(items)
            .exportableToServices(items)
            .onDeleteCommand(perform: nothing ? nil : {
                dispatch.sync(RaindropsAction.deleteMany(pick))
            })
    }
}
