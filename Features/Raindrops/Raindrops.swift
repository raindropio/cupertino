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
            style: collectionViewStyle,
            header: header
        ) { raindrop in
            Label(raindrop.title, systemImage: "bookmark")
        }
            .contextAction(contextAction)
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
                        collectionViewStyle = collectionViewStyle == .list ? .grid : .list
                    }
                }
            }
        
//        List(selection: $selection) {
//            header()
//
//            Section {
//                ForEach(Raindrop.preview) { raindrop in
//                    Label(raindrop.title, systemImage: "bookmark")
//                        .tag(raindrop)
//                }
//                    .onDelete { index in
//
//                    }
//            }
//        }
//            .listStyle(.inset)
//            .contextAction(forSelectionType: Raindrop.self) {
//                if $0.count == 1, let raindrop = $0.first {
//                    contextAction?(raindrop)
//                }
//            }
    }
}
