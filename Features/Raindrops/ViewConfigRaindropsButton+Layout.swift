import SwiftUI
import API

extension ViewConfigRaindropsButton {
    struct Layout: View {
        @EnvironmentObject private var dispatch: Dispatcher

        var find: FindBy
        var view: CollectionView
        
        var body: some View {
            Picker(
                "Layout",
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
                .pickerStyle(.inline)
        }
    }
}
