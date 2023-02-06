import SwiftUI
import UI
import API

struct WebHighlights {
    @EnvironmentObject private var page: WebPage
    @EnvironmentObject private var r: RaindropsStore
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.sendWebMessage) private var _send
    @State private var loading = false
    
    private static let channel = "rdh"
    
    private var raindrop: Raindrop? {
        guard let url = page.url else { return nil }
        return r.state.item(url) ?? .new(link: url)
    }
}

extension WebHighlights: ViewModifier {
    private func onMessageFromPage(_ event: Event) async {
        switch event {
        //highlighting script is loaded
        case .ready:
            await reload()
            
        //add new
        case .add(let highlight):
            guard !loading, var raindrop else { return }
            
            raindrop.highlights.append(highlight)

            try? await dispatch(
                raindrop.isNew ? RaindropsAction.create(raindrop) : RaindropsAction.update(raindrop)
            )
            
        //updated
        case .update(let updated):
            guard !loading, var raindrop else { return }

            guard let index = raindrop.highlights.firstIndex (where: { $0.id == updated._id })
            else { return }
            
            if let text = updated.text {
                raindrop.highlights[index].text = text
            }
            if let note = updated.note {
                raindrop.highlights[index].note = note
            }
            if let color = updated.color {
                raindrop.highlights[index].color = color
            }
            
            try? await dispatch(RaindropsAction.update(raindrop))
            
        //removed
        case .remove(let removed):
            guard !loading, var raindrop else { return }

            guard let index = raindrop.highlights.firstIndex (where: { $0.id == removed._id })
            else { return }
            
            raindrop.highlights[index].text = ""
            
            try? await dispatch(RaindropsAction.update(raindrop))
            
        case .unknown:
            break
        }
    }
    
    @Sendable
    private func reload() async {
        guard page.progress == 1 else { return }
        guard let url = page.url else { return }
        
        if raindrop?.isNew == true {
            loading = true
        }
        
        try? await dispatch(RaindropsAction.lookup(url))
        try? await send(.config(.init(enabled: true, nav: true, pro: true)))
        try? await send(.apply(raindrop?.highlights ?? []))
        
        loading = false
    }
    
    private func send(_ action: Action) async throws {
        try await _send(page, channel: Self.channel, message: action)
    }
    
    func body(content: Content) -> some View {
        content
            .onWebMessage(page, channel: Self.channel, receive: onMessageFromPage)
            .task(id: page.url, reload)
            .task(id: page.progress, reload)
            .task(id: raindrop?.highlights, reload)
    }
}
