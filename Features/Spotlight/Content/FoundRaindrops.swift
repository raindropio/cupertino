import SwiftUI
import API
import UI

struct FoundRaindrops: View {
    @EnvironmentObject private var r: RaindropsStore
    var find: FindBy
    
    var body: some View {        
        Section {
            if find.isSearching {
                Memorized(
                    find: find,
                    status: r.state.exists(find) ? r.state.status(find) : .loading,
                    items: Array(r.state.items(find).prefix(Rest.raindropsPerPage))
                )
            }
        } header: {
            if find.isSearching {
                Header(
                    find: find,
                    total: r.state.total(find)
                )
            }
        }
    }
}

extension FoundRaindrops {
    fileprivate struct Memorized: View {
        var find: FindBy
        var status: RaindropsState.Segment.Status
        var items: [Raindrop]
        
        var body: some View {
            if items.isEmpty {
                switch status {
                case .loading:
                    ForEach(10000000000...10000000005, id: \.self) {
                        Text("\($0)")
                    }
                        .redacted(reason: .placeholder)
                    
                case .error:
                    Admonition("Error loading", role: .danger)
                    
                case .idle, .notFound:
                    Text("No bookmarks found")
                        .foregroundStyle(.secondary)
                        .disabled(true)
                }
            } else {
                Results(find: find, items: items)
            }
        }
    }
}

extension FoundRaindrops {
    fileprivate struct Results: View {
        @EnvironmentObject private var event: SpotlightEvent
        var find: FindBy
        var items: [Raindrop]

        var body: some View {
            ForEach(items) { item in
                Button {
                    event.press(.raindrop(item))
                } label: {
                    Single(item: item)
                }
            }
            
            Button {
                event.press(.find(find))
            } label: {
                Text("Continue search")
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.tint)
            }
            .listRowSeparator(.hidden, edges: .bottom)
            .listRowSeparator(.visible, edges: .top)
        }
    }
}

extension FoundRaindrops {
    fileprivate struct Single: View {
        var item: Raindrop

        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                Thumbnail(item.cover, width: 60, height: 50)
                    .cornerRadius(3)
                
                VStack(alignment: .leading, spacing: 3) {
                    RaindropTitleExcerpt(item)
                        .lineLimit(2)
                    
                    RaindropMeta(item)
                }
            }
        }
    }
}

extension FoundRaindrops {
    fileprivate struct Header: View {
        @EnvironmentObject private var event: SpotlightEvent
        
        var find: FindBy
        var total: Int

        var body: some View {
            HStack {
                Text("Bookmarks")
                
                Spacer()
                
                if total > 0 {
                    Button {
                        event.press(.find(find))
                    } label: {
                        Text("Show all (") +
                        Text(total, format: .number) +
                        Text(")")
                    }
                    .contentTransition(.numericText())
                }
            }
        }
    }
}
