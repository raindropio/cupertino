import SwiftUI
import API
import UI
import Backport
import Common

struct SuggestedFilters: View {
    @EnvironmentObject private var f: FiltersStore
    @Binding var find: FindBy
    
    var body: some View {
        Memorized(
            find: $find,
            tags: f.state.tags(find),
            simple: f.state.simple(find),
            created: f.state.created(find)
        )
    }
}

extension SuggestedFilters {
    fileprivate struct Memorized: View {
        @Binding var find: FindBy
        var tags: [Filter]
        var simple: [Filter]
        var created: [Filter]
        
        var body: some View {
            Section {
                if !tags.isEmpty && !simple.isEmpty && !created.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
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
                                    Label("Tags", systemImage: "number")
                                }
                            }
                            
                            ForEach(simple) { item in
                                Button {
                                    find.filters.append(item)
                                } label: {
                                    FilterRow(item)
                                }
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
                                    Label("Creation date", systemImage: "calendar")
                                }
                                    .tint(Filter.Kind.created("").color)
                            }
                        }
                        .transition(.move(edge: .trailing))
                        .scenePadding(.horizontal)
                    }
                    .labelStyle(LS())
                    .clearSection()
                }
            }
        }
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
