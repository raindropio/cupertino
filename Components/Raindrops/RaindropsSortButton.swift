import SwiftUI
import API

struct RaindropsSortButton: View {
    @EnvironmentObject private var raindrops: RaindropsStore
    var find: FindBy
    
    var body: some View {
        Memorized(find: find, sort: raindrops.state.sort(find))
            .disabled(raindrops.state.isEmpty(find))
    }
}

extension RaindropsSortButton {
    fileprivate struct Memorized: View {
        @EnvironmentObject private var dispatch: Dispatcher

        var find: FindBy
        var sort: SortBy
        
        var body: some View {
            Picker(
                "Sort",
                selection: .init(get: {
                    sort
                }, set: { by in
                    dispatch.sync(RaindropsAction.sort(find, by))
                })
            ) {
                ForEach(SortBy.someCases(for: find)) {
                    Label($0.title, systemImage: $0.systemImage)
                        .tag($0)
                }
            }
        }
    }
}
