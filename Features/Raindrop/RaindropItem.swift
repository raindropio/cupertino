import SwiftUI
import API
import UI

struct RaindropItem {
    @EnvironmentObject private var sheet: RaindropSheet
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
            if container?.hide.contains(.cover) != true {
                RaindropCover(raindrop, view: container?.view, width: container?.coverWidth)
                   .equatable()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                RaindropTitleExcerpt(raindrop)
                    .lineLimit(3)
                
                if container?.hide.contains(.tags) != true {
                    RaindropLinks(raindrop: raindrop)
                }
                                
                if container?.view == .grid {
                    Spacer(minLength: 0)
                }
                
                if container?.hide.contains(.info) != true {
                    RaindropMeta(raindrop)
                }
            }
                .frame(maxWidth: .infinity, alignment: .leading)
        }
            .swipeActions(edge: .leading) {
                Link(destination: raindrop.link) {
                    Label("Open", systemImage: "safari")
                }
            }
            .swipeActions(edge: .trailing) {
                Button { sheet.edit(raindrop.id) } label: {
                    Label("More", systemImage: "ellipsis.circle")
                }

                Button(role: .destructive) {
                    dispatch.sync(RaindropsAction.delete(raindrop.id))
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                    .tint(.red)
                
                ShareLink(item: raindrop.link)
                    .tint(.blue)
            }
            .onDrag {
                raindrop.itemProvider
            }
            .contentTransition(.identity)
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
                    if container?.coverRight == true {
                        parts.value.1
                    }
                    parts.value.0
                        .cornerRadius(3)
                        .padding(.top, 4)
                    if container?.coverRight == false {
                        parts.value.1
                    }
                }
                
            case .simple:
                HStack(alignment: .top, spacing: 14) {
                    if container?.coverRight == true {
                        parts.value.1
                    }
                    parts.value.0
                        .padding(.top, 4)
                    if container?.coverRight == false {
                        parts.value.1
                    }
                }
                
            case .grid:
                VStack(alignment: .leading, spacing: 0) {
                    parts.value.0
                    parts.value.1
                        .padding(container?.hide.allExceptCover == true ? 0 : 12)
                }
                
            case .masonry:
                VStack(alignment: .leading, spacing: 0) {
                    parts.value.0
                    parts.value.1
                        .padding(container?.hide.allExceptCover == true ? 0 : 12)
                }
            }
        }
    }
}
