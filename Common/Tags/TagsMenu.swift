import SwiftUI
import API

func TagsMenu(_ tags: Set<String>) -> some View {
    _TagsMenu(tags: tags)
}

func TagsMenu(_ filters: Set<Filter>) -> some View {
    _TagsMenu(tags: .init(
        filters
            .compactMap {
                switch $0.kind {
                case .tag(let tag): return tag
                default: return nil
                }
            }
    ))
}

func TagsMenu(_ findBy: Set<FindBy>) -> some View {
    TagsMenu(.init(
        findBy.flatMap { $0.filters }
    ))
}


fileprivate struct _TagsMenu: View {
    @EnvironmentObject private var event: TagEvent
    @EnvironmentObject private var dispatch: Dispatcher

    var tags: Set<String>
    
    var body: some View {
        if tags.isEmpty {
            Menu {
                Button("By name") { dispatch.sync(FiltersAction.sort(.title)) }
                Button("By count") { dispatch.sync(FiltersAction.sort(.count)) }
            } label: {
                Label("Sort tags", systemImage: "number")
            }
        }
        
        if let tag = tags.first, tags.count == 1 {
            Button { event.rename(tag) } label: {
                Label("Rename", systemImage: "pencil")
            }
            .tint(.accentColor)
        }
        
        if tags.count > 1 {
            Button { event.merge(tags) } label: {
                Label("Merge", systemImage: "arrow.triangle.merge")
            }
        }
            
        if !tags.isEmpty {
            Button(role: .destructive) { event.delete(tags) } label: {
                Label("Delete", systemImage: "trash")
            }
                .tint(.red)
        }
    }
}
