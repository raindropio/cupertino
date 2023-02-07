import SwiftUI
import API

public struct RaindropEditStack<C: View>: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var r: RaindropsStore
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var draft = Raindrop.new()
    
    var id: Raindrop.ID
    var content: (Binding<Raindrop>) -> C
    
    public init(_ id: Raindrop.ID, content: @escaping (Binding<Raindrop>) -> C) {
        self.id = id
        self.content = content
    }
    
    //version from store
    private var stored: Raindrop? {
        r.state.item(id)
    }
    
    //auto-save for existing bookmarks
    private func saveOnClose() {
        guard !draft.isNew else { return }
        dispatch.sync(RaindropsAction.update(draft))
    }
    
    public var body: some View {
        NavigationStack {
            if draft.isNew {
                EmptyView()
            } else {
                content($draft)
            }
        }
            .task(id: stored) {
                if let stored {
                    draft = stored
                } else {
                    draft = .new()
                    dismiss()
                }
            }
            .onDisappear(perform: saveOnClose)
    }
}
