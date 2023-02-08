import SwiftUI
import API
import UI

struct RaindropLinks: View {
    @EnvironmentObject private var event: RaindropsEvent
    @Environment(\.raindropsContainer) private var container
    
    var raindrop: Raindrop
    
    var kinds: [Filter.Kind] {
        raindrop.important ? [.important] : [] +
        raindrop.tags.map { .tag($0) }
    }
    
    func press(_ kind: Filter.Kind) {
        event.press(.filter(.init(kind)))
    }
    
    func press(_ collection: Int) {
        event.press(.collection(collection))
    }

    var body: some View {
        if raindrop.collection != container?.collectionId || !kinds.isEmpty {
            WStack(spacingX: 6, spacingY: 6) {
                if raindrop.collection != container?.collectionId {
                    Button { press(raindrop.collection) } label: {
                        CollectionLabel(raindrop.collection).badge(0)
                    }
                        .tint(.secondary)
                }
                
                ForEach(kinds, id: \.title) { kind in
                    Button { press(kind) } label: {
                        FilterRow(.init(kind))
                    }
                        .tint(kind.color)
                }
            }
                .buttonStyle(.chip)
                .controlSize(.small)
                .imageScale(.small)
                .padding(.top, 4)
        }
    }
}
