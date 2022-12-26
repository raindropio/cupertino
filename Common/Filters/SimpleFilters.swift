import SwiftUI
import API
import Backport

struct SimpleFilters<T: Hashable>: View {
    @EnvironmentObject private var f: FiltersStore
    var tag: (Filter) -> T
    
    var body: some View {
        Memorized(
            filters: f.state.simple(),
            tag: tag
        )
    }
}

extension SimpleFilters {
    struct Memorized: View {
        var filters: [Filter]
        var tag: (Filter) -> T

        var body: some View {
            ForEach(filters) {
                FilterRow($0)
                    .backport.tag(tag($0))
            }
        }
    }
}

extension SimpleFilters where T == Filter {
    init() {
        self.tag = { $0 }
    }
}

extension SimpleFilters where T == FindBy {
    init() {
        self.tag = { .init($0) }
    }
}
