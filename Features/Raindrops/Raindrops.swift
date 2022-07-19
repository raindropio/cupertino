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
    
    var body: some View {
        CollectionView(
            Raindrop.preview,
            selection: $selection,
            style: .grid,
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
                        selection = .init(Raindrop.preview.map { $0.id })
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
