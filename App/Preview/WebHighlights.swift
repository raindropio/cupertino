import SwiftUI
import UI
import API

struct WebHighlights {
    @EnvironmentObject private var page: WebPage
    @EnvironmentObject private var r: RaindropsStore
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.sendWebMessage) private var _send
    @State private var ready: UUID?
    
    private static let channel = "rdh"
    
    private var raindrop: Raindrop? {
        guard let url = page.url else { return nil }
        return r.state.item(url)
    }
}

extension WebHighlights: ViewModifier {
    private func send(_ action: Action) async throws {
        try await _send(page, channel: Self.channel, message: action)
    }
    
    @Sendable
    private func sendChanges() async {
        guard ready != nil, page.progress == 1 else { return }
        
        try? await send(.config(.init(enabled: true, nav: true, pro: true)))
        try? await send(.apply(raindrop?.highlights ?? []))
    }
    
    private func react(_ event: Event) async {
        guard let url = page.url else { return }

        switch event {
        //highlighting script is ready
        case .ready:
            ready = .init()
            
        //add new
        case .add(let highlight):
            try? await dispatch(HighlightsAction.add(url, highlight))
            
        //updated
        case .update(let updated):
            guard var highlight = raindrop?.highlights.first (where: { $0.id == updated._id }) else { return }
            
            if let text = updated.text {
                highlight.text = text
            }
            if let note = updated.note {
                highlight.note = note
            }
            if let color = updated.color {
                highlight.color = color
            }
            
            try? await dispatch(HighlightsAction.update(url, highlight))
            
        //removed
        case .remove(let removed):
            try? await dispatch(HighlightsAction.delete(url, removed._id))
            
        case .unknown:
            break
        }
    }
    
    func body(content: Content) -> some View {
        content
            .onWebMessage(page, channel: Self.channel, receive: react)
            .task(id: ready, sendChanges)
            .task(id: page.progress, sendChanges)
            .task(id: raindrop?.highlights, sendChanges)
    }
}
