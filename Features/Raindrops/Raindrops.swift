import SwiftUI
import API
import UI

struct Raindrops<Header: View>: View {
    //MARK: - Props
    @Binding var search: SearchQuery
    @ViewBuilder var header: () -> Header
    
    //MARK: - Optional actions
    var contextAction: ((_ raindrop: Raindrop) -> Void)?
    func contextAction(_ action: ((_ raindrop: Raindrop) -> Void)?) -> Self {
        var copy = self; copy.contextAction = action; return copy
    }

    //MARK: - State
    @State private var selection = Set<Raindrop.ID>()
    @State private var collectionViewStyle = CollectionViewStyle.list
    
    var body: some View {
        CollectionView(
            Raindrop.preview,
            selection: $selection,
            style: collectionViewStyle
        ) { raindrop in
            Label(raindrop.title, systemImage: "bookmark")
        } header: {
            header()
        } footer: {
            Text("Footer")
        }
            .contextAction(contextAction)
            .reorderAction { item, to in
                print("reorder \(item.title) to \(to)")
            }
            .toolbar {
                ToolbarItem {
                    EditButton()
                }
                
                ToolbarItem {
                    Button("All") {
                        selection = selection.isEmpty ? .init(Raindrop.preview.map { $0.id }) : .init()
                    }
                }
                
                ToolbarItem {
                    Button("Toggle") {
                        collectionViewStyle = collectionViewStyle == .list ? .grid(250) : .list
                    }
                }
            }
    }
}
