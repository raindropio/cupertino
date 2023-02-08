import SwiftUI
import API

public func RaindropStack<C: View>(_ id: Raindrop.ID, content: @escaping (Binding<Raindrop>) -> C) -> some View {
    ById(id: id, content: content)
}

public func RaindropStack<C: View>(_ url: URL, content: @escaping (Binding<Raindrop>) -> C) -> some View {
    ByURL(url: url, content: content)
}

public func RaindropStack<C: View>(_ raindrop: Raindrop, content: @escaping (Binding<Raindrop>) -> C) -> some View {
    ByURL(raindrop: raindrop, content: content)
}

//MARK: - Existing
fileprivate struct ById<C: View>: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var r: RaindropsStore
    @State private var draft = Raindrop.new()
    
    var id: Raindrop.ID
    var content: (Binding<Raindrop>) -> C
    
    //version from store
    private var stored: Raindrop? {
        r.state.item(id)
    }
    
    var body: some View {
        Stack(draft: $draft, content: content)
            .redacted(reason: draft.isNew ? .placeholder : [])
            .task(id: stored) {
                if let stored {
                    draft = stored
                } else {
                    draft = .new()
                    dismiss()
                }
            }
    }
}

//MARK: - New/Existing
fileprivate struct ByURL<C: View>: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var r: RaindropsStore
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var draft = Raindrop.new()
    @State private var loading = false
    private var blank = Raindrop.new()
        
    var url: URL
    var content: (Binding<Raindrop>) -> C
    
    public init(url: URL, content: @escaping (Binding<Raindrop>) -> C) {
        self.url = url
        self.blank = .new(link: url)
        self.content = content
    }
    
    public init(raindrop: Raindrop, content: @escaping (Binding<Raindrop>) -> C) {
        self.url = raindrop.link
        self.blank = raindrop
        self._draft = .init(initialValue: blank)
        self.content = content
    }
    
    //version from store
    private var stored: Raindrop {
        r.state.item(url) ?? blank
    }
    
    //maybe existing?
    @Sendable private func lookup() async {
        defer { loading = false }
        loading = true
        
        let rest = Rest()
        
        //lookup for url and load meta at the same time
        async let fMeta = rest.importUrlParse(url)
        async let fLookup: () = dispatch(RaindropsAction.lookup(url))
        let result = try? await (fMeta, fLookup)
        
        if draft.isNew, let meta = result?.0 {
            draft = meta
        }
    }
    
    var body: some View {
        Stack(draft: $draft, loading: loading, content: content)
            .task(id: stored) { draft = stored }
            .task(id: url, lookup)
    }
}

//MARK: - Common
fileprivate struct Stack<C: View>: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var dispatch: Dispatcher

    @Binding var draft: Raindrop
    var loading = false
    var content: (Binding<Raindrop>) -> C
    
    //auto-save for existing bookmarks
    private func saveOnClose() {
        guard !draft.isNew else { return }
        dispatch.sync(RaindropsAction.update(draft))
    }
    
    var body: some View {
        NavigationStack {
            content($draft)
                .animation(nil, value: [loading, draft.isNew])
                .disabled(loading)
                .opacity(loading ? 0.7 : 1)
                .animation(.default, value: [loading, draft.isNew])
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(draft.isNew ? "Cancel" : "Done", action: dismiss.callAsFunction)
                    }
                }
        }
            .interactiveDismissDisabled(draft.isNew)
            .onDisappear(perform: saveOnClose)
    }
}
