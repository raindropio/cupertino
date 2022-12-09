import SwiftUI
import API
import UI

struct BrowseLoadMore: View {
    @EnvironmentObject private var raindrops: RaindropsStore
    var find: FindBy
    
    var body: some View {
        Memorized(
            find: find,
            more: raindrops.state.more(find),
            total: raindrops.state.total(find)
        )
    }
}

extension BrowseLoadMore {
    fileprivate struct Memorized: View {
        @EnvironmentObject private var dispatch: Dispatcher

        var find: FindBy
        var more: RaindropsState.Segment.Status
        var total: Int
        
        var body: some View {
            if total > 0 {
                VStack {
                    Button {
                        dispatch.sync(RaindropsAction.more(find))
                    } label: {
                        switch more {
                        case .idle:
                            Label("Load more", systemImage: "arrow.clockwise")
                            
                        case .loading:
                            ProgressView()
                            
                        case .notFound:
                            Text("That's all folks!")
                            
                        case .error:
                            Label("Error", systemImage: "exclamationmark.triangle")
                                .tint(.red)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 32)
                .disabled(more == .notFound)
                .scenePadding(.horizontal)
                .clearSection()
            }
        }
    }
}
