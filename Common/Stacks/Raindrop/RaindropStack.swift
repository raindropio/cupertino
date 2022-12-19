import SwiftUI
import API
import UI
import Backport

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
    private var isNew: Bool {
        raindrop.id == 0
    }
    
    private func commit() async throws {
        try await dispatch(isNew ? RaindropsAction.create(raindrop) : RaindropsAction.update(raindrop))
        dismiss()
    }
    
    private func saveOnClose() {
        guard !isNew else { return }
        Task { try? await commit() }
    }
    
    @Sendable
    private func findNew() async {
        guard isNew else { return }
        loading = true
        try? await dispatch(RaindropsAction.find($raindrop))
        loading = false
    }
}

extension RaindropStack: View {
    public var body: some View {
        Backport.NavigationStack {
            Form {
                Fields(raindrop: $raindrop)
                Footer(raindrop: $raindrop, loading: $loading)
            }
                .animation(nil, value: [loading, isNew])
                .disabled(loading)
                .opacity(loading ? 0.7 : 1)
                .animation(.default, value: [loading, isNew])
                .submitLabel(.done)
                .onSubmit(commit)
                .navigationTitle(isNew ? "New bookmark" : "Edit bookmark")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: isNew ? .cancellationAction : .confirmationAction) {
                        Button(isNew ? "Cancel" : "Done", action: dismiss.callAsFunction)
                    }
                }
        }
            //prevent drag to dismiss for new items
            .interactiveDismissDisabled(isNew)
            //find bookmark for new
            .task(priority: .background, findNew)
            //auto-save for existing bookmarks
            .onDisappear(perform: saveOnClose)
    }
}
