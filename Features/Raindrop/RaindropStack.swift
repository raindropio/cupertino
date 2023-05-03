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

public func RaindropStack<C: View>(_ raindrop: Binding<Raindrop>, content: @escaping (Binding<Raindrop>) -> C) -> some View {
    Stack(draft: raindrop, content: content)
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
    
    private func changed() {
        if let stored {
            draft = stored
        } else {
            draft = .new()
            dismiss()
        }
    }
    
    var body: some View {
        Group {
            if draft.isNew {
                Text("")
            } else {
                Stack(draft: $draft, content: content)
            }
        }
            .onAppear(perform: changed)
            .task(id: stored) { changed() }
    }
}

//MARK: - New/Existing
fileprivate struct ByURL<C: View>: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var r: RaindropsStore
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var draft = Raindrop.new()
    @State private var loading = true
    private var blank = Raindrop.new()
        
    var url: URL
    var content: (Binding<Raindrop>) -> C
    
    init(url: URL, content: @escaping (Binding<Raindrop>) -> C) {
        self.url = url
        self.blank = .new(link: url)
        self.content = content
    }
    
    init(raindrop: Raindrop, content: @escaping (Binding<Raindrop>) -> C) {
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
        loading = true
        
        try? await dispatch(RaindropsAction.lookup(url))
        
        //useful when sharing existing page, but with additional highlights
        draft.append(highlights: blank.highlights)
        
        loading = false
    }

    var body: some View {
        Stack(draft: $draft, loading: loading, content: content)
            .onAppear { draft = stored }
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
                .disabled(loading)
                .animation(.easeInOut(duration: 0.2), value: [loading, draft.isNew])
                .toolbar {
                    ToolbarItem(placement: draft.isNew ? .cancellationAction : .confirmationAction) {
                        Button(draft.isNew ? "Cancel" : "Done", action: dismiss.callAsFunction)
                    }
                }
        }
            .task(id: draft.isNew, priority: .background) {
                try? await dispatch(RaindropsAction.enrich($draft))
            }
            .onDisappear(perform: saveOnClose)
    }
}
