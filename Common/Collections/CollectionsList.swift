import SwiftUI
import API

public struct CollectionsList<C: View> {
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var search = ""

    @Binding var selection: Int?
    var matching: CollectionsListMatching = .all
    var searchable: Bool = true
    var custom: (() -> C)?
    
    public init(
        selection: Binding<Int?>,
        matching: CollectionsListMatching = .all,
        searchable: Bool = true,
        custom: @escaping () -> C
    ) {
        self._selection = selection
        self.matching = matching
        self.searchable = searchable
        self.custom = custom
    }
}

extension CollectionsList: View {
    public var body: some View {
        List(selection: $selection) {
            if search.isEmpty {
                if matching != .nestable {
                    Section {
                        if matching == .all {
                            SystemCollectionRow(id: 0)
                                .tag(0)
                        }
                        if matching != .nestable {
                            SystemCollectionRow(id: -1)
                                .dropRaindrop(to: -1)
                                .tag(-1)
                        }
                        custom?()
                    }
                }
                
                CollectionsTree()
                
                if matching == .all {
                    Section {
                        SystemCollectionRow(id: -99)
                            .dropRaindrop(to: -99)
                            .tag(-99)
                    }
                }
            } else {
                FindCollections(search: search)
            }
        }
            //appearance
            #if os(iOS)
            .modifier(Animation())
            .listStyle(.insetGrouped)
            .headerProminence(.increased)
            #endif
            //features
            .modifier(Menus())
            .modifier(Search(enabled: searchable, search: $search))
            .overlay(content: Empty.init)
            //reload
            .refreshable {
                try? await dispatch(CollectionsAction.load)
            }
            .task(priority: .background) {
                try? await dispatch(CollectionsAction.load)
            }
    }
}

public enum CollectionsListMatching {
    case all
    case nestable
    case insertable
}

extension CollectionsList where C == EmptyView {
    public init(
        selection: Binding<Int?>,
        matching: CollectionsListMatching = .all,
        searchable: Bool = true
    ) {
        self._selection = selection
        self.matching = matching
        self.searchable = searchable
        self.custom = nil
    }
}
