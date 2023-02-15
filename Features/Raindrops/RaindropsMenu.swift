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
    @EnvironmentObject private var sheet: RaindropSheet
    @EnvironmentObject private var r: RaindropsStore
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.editMode) private var editMode

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
                    
                    DeepLink(.raindrop(.preview(item.id))) {
                        Label("Preview", systemImage: "eyeglasses")
                    }

                    if item.file == nil {
                        DeepLink(.raindrop(.cache(item.id))) {
                            Label("Permanent copy", systemImage: "clock.arrow.circlepath")
                        }
                    }
                    
                    Button { sheet.edit(item.id) } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                }
            }
            
            //copy
            CopyButton(items: items.map { $0.link })

            //share
            ShareLink(items: items.map { $0.link })
            
            //move
            Button { sheet.move(pick) } label: {
                Label("Move", systemImage: "folder")
            }
            
            //add tags
            Button { sheet.addTags(pick) } label: {
                Label("Add tags", systemImage: "number")
            }

            //delete
            Button(role: .destructive) { sheet.delete(pick) } label: {
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
                            editMode?.wrappedValue = .inactive
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
