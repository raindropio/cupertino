import SwiftUI
import API

public struct RaindropNewStack<C: View>: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var r: RaindropsStore
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var draft = Raindrop.new()
    @State private var loading = false
    private var blank = Raindrop.new()
    
    var url: URL
    var content: (Binding<Raindrop>) -> C
    
    public init(_ url: URL, content: @escaping (Binding<Raindrop>) -> C) {
        self.url = url
        self.content = content
    }
    
    public init(_ raindrop: Raindrop, content: @escaping (Binding<Raindrop>) -> C) {
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
        try? await dispatch(RaindropsAction.lookup(url))
    }
    
    public var body: some View {
        NavigationStack {
            content($draft)
                .animation(nil, value: loading)
                .disabled(loading)
                .opacity(loading ? 0.7 : 1)
                .animation(.default, value: loading)
        }
            .task(id: stored) { draft = stored }
            .task(id: url, lookup)
            //prevent drag to dismiss for new items
            .interactiveDismissDisabled(draft.isNew)
    }
}
