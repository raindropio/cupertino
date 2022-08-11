import SwiftUI
import API
import UI

struct Raindrops<Header: View>: View {
    //MARK: - Props
    @Binding var search: SearchQuery
    @ViewBuilder var header: () -> Header
    
    //MARK: - Optional actions
    var contextAction: ((_ id: Raindrop.ID) -> Void)?
    func contextAction(_ action: ((_ id: Raindrop.ID) -> Void)?) -> Self {
        var copy = self; copy.contextAction = action; return copy
    }

    //MARK: - State
    @State private var selection = Set<Raindrop.ID>()
    @State private var collectionViewStyle = CollectionViewLayout.list
    
    var body: some View {
        CollectionView(collectionViewStyle, selection: $selection) {
            header()
            
            DataSource(Raindrop.preview) { raindrop in
                Text(raindrop.title)
            }
            
            Text("Footer")
        } action: {
            contextAction?($0)
        } reorder: { id, to in
            print("reorder \(id) to \(to)")
        } contextMenu: { selection in
            Button("aaa") {}
        }
            .listStyle(.inset)
            .refreshable {
                try? await Task.sleep(until: .now + .seconds(1), clock: .continuous)
            }
            .toolbar {
                #if os(iOS)
                ToolbarItem {
                    EditButton()
                }
                #endif
                
                ToolbarItem {
                    Button("All") {
                        selection = selection.isEmpty ? .init(Raindrop.preview.map { $0.id }) : .init()
                    }
                }
                
                ToolbarItem {
                    Button("Toggle") {
                        switch collectionViewStyle {
                        case .list: collectionViewStyle = .grid(100)
                        case .grid(_): collectionViewStyle = .list
                        }
                    }
                }
            }
    }
}
