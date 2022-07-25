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
    @State private var collectionViewStyle = CollectionViewStyle.list(20)
    
    var body: some View {
        CollectionView(
            Raindrop.preview,
            selection: $selection,
            style: collectionViewStyle
        ) { raindrop in
            Text(raindrop.title)
        } header: {
            header()
        } footer: {
            Text("Footer")
        }
            .contextAction(contextAction)
            .reorderAction { item, to in
                print("reorder \(item.title) to \(to)")
            }
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
                        case .list(_): collectionViewStyle = .grid(.init(width: 250, height: 40))
                        case .grid(_): collectionViewStyle = .list(20)
                        }
                    }
                }
            }
    }
}
