import SwiftUI
import API
import UI

public struct RaindropStack {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.dismiss) private var dismiss
    @State private var loading = false
    @State private var raindrop: Raindrop
    
    public init(_ link: URL) {
        self._raindrop = State(initialValue: .new(link: link))
    }
    
    public init(_ raindrop: Raindrop) {
        self._raindrop = State(initialValue: raindrop)
    }
}

extension RaindropStack {
    private func commit() async throws {
        try await dispatch(raindrop.isNew ? RaindropsAction.create(raindrop) : RaindropsAction.update(raindrop))
        dismiss()
    }
    
    private func saveOnClose() {
        guard !raindrop.isNew else { return }
        Task { try? await commit() }
    }
    
    @Sendable
    private func findNew() async {
        guard raindrop.isNew else { return }
        loading = true
        try? await dispatch(RaindropsAction.find($raindrop))
        loading = false
    }
}

extension RaindropStack: View {
    public var body: some View {
        NavigationStack {
            Form {
                Fields(raindrop: $raindrop)
                Actions(raindrop: $raindrop)
            }
                .modifier(Toolbar(raindrop: $raindrop))
                .animation(nil, value: [loading, raindrop.isNew])
                .disabled(loading)
                .opacity(loading ? 0.7 : 1)
                .animation(.default, value: [loading, raindrop.isNew])
                .submitLabel(.done)
                .onSubmit(commit)
                .navigationTitle((raindrop.isNew ? "New" : "Edit") + " \(raindrop.type.single.localizedLowercase)")
                .navigationBarTitleDisplayMode(.inline)
        }
            //prevent drag to dismiss for new items
            .interactiveDismissDisabled(raindrop.isNew)
            //find bookmark for new
            .task(priority: .background, findNew)
            //auto-save for existing bookmarks
            .onDisappear(perform: saveOnClose)
    }
}
