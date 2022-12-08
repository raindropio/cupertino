import SwiftUI
import API
import UI

extension BrowseItems {
    struct Empty: View {
        @EnvironmentObject private var r: RaindropsStore
        @EnvironmentObject private var dispatch: Dispatcher

        var find: FindBy
        
        var body: some View {
            Memorized(find: find, status: r.state.status(find))
                .animation(.default, value: r.state.status(find))
        }
    }
}

extension BrowseItems.Empty {
    struct Memorized: View {
        @EnvironmentObject private var dispatch: Dispatcher

        var find: FindBy
        var status: RaindropsState.Segment.Status
        
        var body: some View {
            Group {
                switch status {
                case .idle:
                    if find.isSearching {
                        EmptyState("Nothing found") {
                            Image(systemName: "magnifyingglass")
                        }
                    } else {
                        EmptyState("Empty") {
                            Image(systemName: "star")
                        }
                    }
                
                case .loading:
                    ProgressView()
                        .progressViewStyle(.circular)
                    
                case .error:
                    EmptyState("Error") {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundStyle(.red)
                    } actions: {
                        Button("Try again") {
                            dispatch.sync(RaindropsAction.load(find))
                        }
                    }
                    
                case .notFound:
                    EmptyState("Not found") {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundStyle(.yellow)
                    }
                }
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scenePadding()
                .padding(.vertical, 100)
                .clearSection()
                .transition(.opacity)
        }
    }
}
