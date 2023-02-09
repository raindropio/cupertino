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
        if (
            raindrop.collection != container?.collectionId ||
            raindrop.important ||
            !raindrop.highlights.isEmpty ||
            !raindrop.tags.isEmpty
        ) {
            WStack(spacingX: 6, spacingY: 6) {
                //collection
                if raindrop.collection != container?.collectionId {
                    Button { press(raindrop.collection) } label: {
                        CollectionLabel(raindrop.collection).badge(0)
                    }
                        .tint(.secondary)
                }
                
                //important
                if raindrop.important {
                    Button { press(.important) } label: {
                        Image(systemName: Filter.Kind.important.systemImage)
                            .symbolVariant(.fill)
                            .foregroundStyle(.tint)
                    }
                        .tint(Filter.Kind.important.color)
                }
                
                //highlights
                if !raindrop.highlights.isEmpty {
                    Button { press(.highlights) } label: {
                        Label("\(raindrop.highlights.count)", systemImage: Filter.Kind.highlights.systemImage)
                    }
                        .tint(Filter.Kind.highlights.color)
                        .allowsHitTesting(false)
                }
                
                //tags
                ForEach(raindrop.tags) { tag in
                    Button(tag) { press(.tag(tag)) }
                }
                    .tint(Filter.Kind.notag.color)
            }
                .buttonStyle(.chip)
                .controlSize(.small)
                .imageScale(.small)
                .padding(.vertical, 4)
        }
    }
}
