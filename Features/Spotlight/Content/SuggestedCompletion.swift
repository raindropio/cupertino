import SwiftUI
import API
import Backport

struct SuggestedCompletion: View {
    @EnvironmentObject private var f: FiltersStore
    var find: FindBy
    
    var body: some View {
        Memorized(
            find: find,
            items: f.state.completion(find)
        )
    }
}

extension SuggestedCompletion {
    fileprivate struct Memorized: View {
        var find: FindBy
        var items: [Filter]
        
        var body: some View {
            Section {
                ForEach(items) { item in
                    FilterRow(item)
                        .swipeActions {
                            TagsMenu(item)
                        }
                        .backport.searchCompletion(item)
                        .listItemTint(item.color)
                }
            } header: {
                if !items.isEmpty {
                    HStack {
                        Text("Suggestions")
                        
                        //TODO: more
//                        Spacer()
//                        
//                        if find.isSearching {
//                            Button("Show all") {}
//                        }
                    }
                }
            }
        }
    }
}

