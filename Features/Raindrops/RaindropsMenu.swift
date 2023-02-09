import SwiftUI
import API
import UI

public func RaindropsMenu(_ pick: RaindropsPick = .some([])) -> some View {
    _Menu(pick: pick)
}

public func RaindropsMenu(_ raindrop: Raindrop) -> some View {
    _Menu(pick: .some([raindrop.id]))
}

public func RaindropsMenu(_ id: Raindrop.ID) -> some View {
    _Menu(pick: .some([id]))
}

public func RaindropsMenu(_ ids: Set<Raindrop.ID>) -> some View {
    _Menu(pick: .some(ids))
}

fileprivate struct _Menu: View {
    @EnvironmentObject private var event: RaindropsEvent
    @EnvironmentObject private var r: RaindropsStore
    @EnvironmentObject private var dispatch: Dispatcher

    var pick: RaindropsPick
    
    private var items: [Raindrop] {
        switch pick {
        case .some(let ids):
            return ids.compactMap(r.state.item)
        case .all(let find):
            return r.state.items(find)
        }
    }
    
    var body: some View {
        if !items.isEmpty {
            //single
            if items.count == 1, let item = items.first {
                Section {
                    Link(destination: item.link) {
                        Label("Open", systemImage: "safari")
                    }

                    Button { event.press(.preview(item.id)) } label: {
                        Label("Preview", systemImage: "eyeglasses")
                    }

                    if item.file == nil {
                        Button { event.press(.cache(item.id)) } label: {
                            Label("Permanent copy", systemImage: "clock.arrow.circlepath")
                        }
                    }
                    
                    Button { event.edit(item.id) } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                }
            }
            
            //copy
            CopyButton(items: items.map { $0.link })

            //share
            ShareLink(items: items.map { $0.link })
            
            //move
            Button { event.move(pick) } label: {
                Label("Move", systemImage: "folder")
            }
            
            //add tags
            Button { event.addTags(pick) } label: {
                Label("Add tags", systemImage: "number")
            }

            //delete
            Button(role: .destructive) { event.delete(pick) } label: {
                Label("Delete", systemImage: "trash")
            }
                .tint(.red)
            
            //more
            Menu {
                Group {
                    //remove tags
                    Menu {
                        Button("Confirm", role: .destructive) {
                            dispatch.sync(RaindropsAction.updateMany(pick, .removeTags))
                        }
                    } label: {
                        Label("Remove tags", systemImage: "tag.slash")
                    }
                }
                    .labelStyle(.titleAndIcon)
            } label: {
                Label("More", systemImage: "ellipsis")
            }
        }
    }
}
