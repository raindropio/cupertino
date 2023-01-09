import SwiftUI
import API
import UI
import Backport
import Common

struct SuggestedFilters: View {
    @EnvironmentObject private var f: FiltersStore
    @Binding var find: FindBy
    
    var count: Int {
        f.state.tags(find).count +
        f.state.simple(find).count +
        f.state.created(find).count
    }
    
    var body: some View {
        Section {
            if count > 0 {
                Memorized(
                    find: $find,
                    tags: f.state.tags(find),
                    simple: f.state.simple(find),
                    created: f.state.created(find)
                )
                    .modifier(Style(compact: find.isSearching))
                    .animation(nil, value: !find.isSearching)
            }
        } header: {
            if count > 0, !find.isSearching {
                Text("Suggestions")
            }
        }
    }
}

extension SuggestedFilters {
    fileprivate struct Memorized: View {
        @Binding var find: FindBy
        var tags: [Filter]
        var simple: [Filter]
        var created: [Filter]
        
        var body: some View {
            if !tags.isEmpty {
                Menu {
                    ForEach(tags) { item in
                        Button {
                            find.filters.append(item)
                        } label: {
                            FilterRow(item)
                        }
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
                Button {
                    find.filters.append(item)
                } label: {
                    FilterRow(item)
                }
                    .listItemTint(item.color)
            }
            
            if !created.isEmpty {
                Menu {
                    ForEach(created) { item in
                        Button {
                            find.filters.append(item)
                        } label: {
                            FilterRow(item)
                        }
                    }
                } label: {
                    Label {
                        Text("Creation date")
                            .foregroundColor(.primary)
                    } icon: {
                        Image(systemName: "calendar")
                    }
                }
                    .listItemTint(Filter.Kind.created("").color)
            }
        }
    }
}

extension SuggestedFilters {
    fileprivate struct Style: ViewModifier {
        var compact: Bool
        
        func body(content: Content) -> some View {
            if compact {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        content
                    }
                    .transition(.move(edge: .trailing))
                    .scenePadding(.horizontal)
                }
                .labelStyle(LS())
                .clearSection()
            } else {
                content
                    .controlSize(.regular)
            }
        }
            
        fileprivate struct LS: LabelStyle {
            public func makeBody(configuration: Configuration) -> some View {
                HStack {
                    configuration.icon
                        .symbolVariant(.fill)
                    
                    configuration.title
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(
                        .tint.opacity(0.15),
                        in: Capsule(style: .continuous)
                    )
            }
        }
    }
}
