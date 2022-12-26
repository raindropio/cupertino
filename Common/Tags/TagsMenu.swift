import SwiftUI
import API

func TagsMenu(_ tags: Set<String>) -> some View {
    _TagsMenu(tags: tags)
}

func TagsMenu(_ tags: Set<FindBy>) -> some View {
    _TagsMenu(tags: .init(
        tags
            .flatMap { $0.filters }
            .compactMap {
                switch $0.kind {
                case .tag(let tag): return tag
                default: return nil
                }
            }
    ))
}

fileprivate struct _TagsMenu: View {
    @EnvironmentObject private var event: TagEvent
    var tags: Set<String>
    
    var body: some View {
        if let tag = tags.first {
            Button {
                event.rename(tag)
            } label: {
                Label("Rename", systemImage: "pencil")
            }
            .tint(.accentColor)
        }
        
        if tags.count > 1 {
            Button {
                event.merge(tags)
            } label: {
                Label("Merge", systemImage: "arrow.triangle.merge")
            }
        }
        
        if !tags.isEmpty {
            Button {
                event.delete(tags)
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
        }
    }
}
