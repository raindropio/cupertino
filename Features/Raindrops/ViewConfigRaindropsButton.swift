import SwiftUI
import API

public struct ViewConfigRaindropsButton: View {
    @EnvironmentObject private var c: CollectionsStore
    @EnvironmentObject private var r: RaindropsStore
    @EnvironmentObject private var cfg: ConfigStore

    var find: FindBy
    
    public init(_ find: FindBy) {
        self.find = find
    }
    
    public var body: some View {
        if !r.state.isEmpty(find) {
            Memorized(
                find: find,
                view: c.state.view(find.collectionId)
            )
        }
    }
}

extension ViewConfigRaindropsButton {
    fileprivate struct Memorized: View {
        var find: FindBy
        var view: CollectionView
        
        var body: some View {
            Menu {
                Group {
                    Layout(find: find, view: view)
                    Show(find: find, view: view)
                    Cover(find: find, view: view)
                }
                    .labelStyle(.titleAndIcon)
            } label: {
                Label(view.title, systemImage: view.systemImage)
                    .foregroundStyle(.tint)
                    .frame(minWidth: 54, maxHeight: .infinity)
            }
                .symbolVariant(.fill)
        }
    }
}
