import SwiftUI
import API

struct RaindropsView: View {
    @EnvironmentObject private var collections: CollectionsStore
    @EnvironmentObject private var raindrops: RaindropsStore

    var find: FindBy
    
    var body: some View {
        Memorized(find: find, view: collections.state.view(find.collectionId))
            .disabled(raindrops.state.isEmpty(find))
    }
}

extension RaindropsView {
    fileprivate struct Memorized: View {
        @EnvironmentObject private var dispatch: Dispatcher

        var find: FindBy
        var view: CollectionView
        
        var body: some View {
            Picker(
                "View",
                selection: .init(get: {
                    view
                }, set: { view in
                    dispatch.sync(CollectionsAction.setView(find.collectionId, view))
                })
            ) {
                ForEach(CollectionView.allCases) {
                    Label($0.title, systemImage: $0.systemImage)
                        .tag($0)
                }
            }
                .symbolVariant(.fill)
        }
    }
}
