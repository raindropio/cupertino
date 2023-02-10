import SwiftUI
import API
import UI

struct SuggestedFilters: View {
    @EnvironmentObject private var f: FiltersStore
    var find: FindBy
    
    var count: Int {
        f.state.tags(find).count +
        f.state.simple(find).count +
        f.state.created(find).count
    }
    
    var body: some View {
        if count > 0 {
            Memorized(
                find: find,
                tags: f.state.tags(find),
                simple: f.state.simple(find),
                created: f.state.created(find)
            )
        }
    }
}

extension SuggestedFilters {
    fileprivate struct Memorized: View {
        var find: FindBy
        var tags: [Filter]
        var simple: [Filter]
        var created: [Filter]
        
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    if !tags.isEmpty {
                        Menu {
                            ForEach(tags) { item in
                                FilterRow(item)
                                    .searchCompletion(item)
                            }
                        } label: {
                            Label {
                                Text("Tagged")
                                    .foregroundColor(.primary)
                            } icon: {
                                Image(systemName: "number")
                            }
                        }
                        .badge(tags.count)
                    }
                    
                    ForEach(simple) { item in
                        SearchCompletionButton(item) {
                            FilterRow(item)
                        }
                            .tint(item.color)
                            .listItemTint(item.color)
                    }
                    
                    if !created.isEmpty {
                        Menu {
                            ForEach(created) { item in
                                FilterRow(item)
                                    .searchCompletion(item)
                            }
                        } label: {
                            Label {
                                Text("Creation date")
                                    .foregroundColor(.primary)
                            } icon: {
                                Image(systemName: "calendar")
                            }
                        }
                            .tint(Filter.Kind.created("").color)
                            .listItemTint(Filter.Kind.created("").color)
                    }
                }
                .transition(.move(edge: .trailing))
                .scenePadding(.horizontal)
                .frame(height: 44)
                .buttonStyle(.chip)
                .menuStyle(.chip)
                .fixedSize()
            }
            .padding(.vertical, 8)
            .clearSection()
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}
