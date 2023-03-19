import SwiftUI
import API

public struct SortRaindropsButton: View {
    @EnvironmentObject private var r: RaindropsStore
    var find: FindBy
    
    public init(_ find: FindBy) {
        self.find = find
    }
    
    public var body: some View {
        Memorized(find: find, sort: r.state.sort(find))
            .disabled(r.state.isEmpty(find))
    }
}

extension SortRaindropsButton {
    fileprivate struct Memorized: View {
        @EnvironmentObject private var dispatch: Dispatcher

        var find: FindBy
        var sort: SortBy
        
        var body: some View {
            Menu {
                Picker(
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
                } label: {}
                    .pickerStyle(.inline)
                    .labelStyle(.titleAndIcon)
            } label: {
                Label(sort.title, systemImage: sort.systemImage)
            }
                .help("Sort")
        }
    }
}
