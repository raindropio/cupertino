import SwiftUI
import API

struct RaindropItem {
    @EnvironmentObject private var event: RaindropsEvent
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.raindropsContainer) private var container
    
    var raindrop: Raindrop
    
    init(_ raindrop: Raindrop) {
        self.raindrop = raindrop
    }
}

extension RaindropItem: View {
    var body: some View {
        Layout {
            RaindropCover(raindrop, view: container?.view)
            
            VStack(alignment: .leading, spacing: 4) {
                RaindropTitleExcerpt(raindrop)
                    .lineLimit(3)
                
                RaindropLinks(raindrop: raindrop)
                                
                if container?.view == .grid {
                    Spacer(minLength: 0)
                }
                
                RaindropMeta(raindrop)
            }
        }
            .swipeActions(edge: .leading) {
                Link(destination: raindrop.link) {
                    Label("Open", systemImage: "safari")
                }
            }
            .swipeActions(edge: .trailing) {
                Button { event.edit(raindrop.id) } label: {
                    Label("More", systemImage: "ellipsis.circle")
                }

                Button(role: .destructive) {
                    dispatch.sync(RaindropsAction.delete(raindrop.id))
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                    .tint(.red)
            }
            .onDrag {
                raindrop.itemProvider
            }
    }
}

extension RaindropItem {
    struct Layout<C: View, D: View>: View {
        @Environment(\.raindropsContainer) private var container
        @ViewBuilder var content: () -> TupleView<(C, D)>
        
        var body: some View {
            let parts = content()
            
            switch container?.view {
            case .list, nil:
                HStack(alignment: .top, spacing: 14) {
                    parts.value.0
                        .cornerRadius(3)
                        .padding(.top, 8)
                    parts.value.1
                }
                
            case .simple:
                HStack(alignment: .top, spacing: 14) {
                    parts.value.0
                        .padding(.top, 8)
                    parts.value.1
                }
                
            case .grid:
                VStack(alignment: .leading, spacing: 0) {
                    parts.value.0
                    parts.value.1
                        .padding(12)
                }
                
            case .masonry:
                VStack(alignment: .leading, spacing: 0) {
                    parts.value.0
                    parts.value.1
                        .padding(12)
                }
            }
        }
    }
}
