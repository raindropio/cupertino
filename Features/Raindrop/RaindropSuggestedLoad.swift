import SwiftUI
import API

struct RaindropSuggestedLoad<C: View>: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @EnvironmentObject private var r: RaindropsStore

    var raindrop: Raindrop
    @ViewBuilder var content: (RaindropSuggestions) -> C
    
    private var suggestions: RaindropSuggestions {
        r.state.suggestions(raindrop.link)
    }
    
    private func load() async {
        try? await dispatch(RaindropsAction.suggest(raindrop))
    }
    
    var body: some View {
        content(suggestions)
            .task(priority: .background) { await load() }
            .task(id: raindrop.lastUpdate) { await load() }
    }
}
