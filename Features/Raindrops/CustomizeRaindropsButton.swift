import SwiftUI
import API

public struct CustomizeRaindropsButton: View {
    @EnvironmentObject private var c: CollectionsStore
    @EnvironmentObject private var r: RaindropsStore

    var find: FindBy
    
    public init(_ find: FindBy) {
        self.find = find
    }
    
    public var body: some View {
        if !r.state.isEmpty(find) {
            Memorized(find: find, view: c.state.view(find.collectionId))
        }
    }
}

extension CustomizeRaindropsButton {
    fileprivate struct Memorized: View {
        @EnvironmentObject private var dispatch: Dispatcher

        var find: FindBy
        var view: CollectionView
        
        var body: some View {
            Menu {
                Group {
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
                        .pickerStyle(.inline)
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
