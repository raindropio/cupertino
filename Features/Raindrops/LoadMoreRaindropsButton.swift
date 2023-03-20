import SwiftUI
import API
import UI

public struct LoadMoreRaindropsButton: View {
    @EnvironmentObject private var r: RaindropsStore
    var find: FindBy
    
    public init(_ find: FindBy) {
        self.find = find
    }
    
    public var body: some View {
        Memorized(
            find: find,
            more: r.state.more(find),
            total: r.state.total(find)
        )
    }
}

extension LoadMoreRaindropsButton {
    fileprivate struct Memorized: View {
        @EnvironmentObject private var dispatch: Dispatcher

        var find: FindBy
        var more: RaindropsState.Segment.Status
        var total: Int
        
        var body: some View {
            if total > 0 {
                Button {
                    dispatch.sync(RaindropsAction.more(find))
                } label: {
                    Group {
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
                    .disabled(more == .notFound)
                    .buttonStyle(.borderless)
            }
        }
    }
}
