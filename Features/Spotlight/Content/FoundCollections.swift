import SwiftUI
import API
import UI
import Backport

struct FoundCollections: View {
    @EnvironmentObject private var c: CollectionsStore
    var find: FindBy
    
    var body: some View {
        let items = c.state.find(find)
        
        Section {
            if find.isSearching {
                Memorized(
                    items: items
                )
            }
        } header: {
            if find.isSearching, !items.isEmpty {
                Header(find: find)
            }
        }
    }
}

extension FoundCollections {
    fileprivate struct Memorized: View {
        @EnvironmentObject private var event: SpotlightEvent
        var items: [UserCollection]
        
        var body: some View {
            ForEach(items) { item in
                Button {
                    event.press(.collection(item))
                } label: {
                    UserCollectionItem(item, withLocation: true)
                }
            }
        }
    }
}

extension FoundCollections {
    fileprivate struct Header: View {
        var find: FindBy

        var body: some View {
            HStack {
                Text("Collections")
                
                //TODO: more
//                Spacer()
//
//                if find.isSearching {
//                    Button("Show all") {}
//                }
            }
        }
    }
}
