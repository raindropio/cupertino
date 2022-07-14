import SwiftUI
import API

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
    @State private var selection = Set<Raindrop>()
    
    var body: some View {
        List(selection: $selection) {
            header()
            
            Section {
                ForEach(Raindrop.preview) { raindrop in
                    Label(raindrop.title, systemImage: "bookmark")
                        .tag(raindrop)
                }
            }
        }
            .contextAction(forSelectionType: Raindrop.self) {
                if $0.count == 1, let raindrop = $0.first {
                    contextAction?(raindrop)
                }
            }
    }
}
