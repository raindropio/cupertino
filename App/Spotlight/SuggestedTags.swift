import SwiftUI
import API
import Backport
import Common

struct SuggestedTags: View {
    @EnvironmentObject private var f: FiltersStore
    var find: FindBy
    
    var body: some View {
        Memorized(
            find: find,
            items: f.state.tags(find)
        )
    }
}

extension SuggestedTags {
    fileprivate struct Memorized: View {
        var find: FindBy
        var items: [Filter]
        
        var body: some View {
            Section {
                ForEach(items) {
                    FilterRow($0)
                        .backport.searchCompletion($0)
                }
            } header: {
                if !items.isEmpty {
                    HStack {
                        Text("Tags")
                        
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

