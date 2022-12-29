import SwiftUI
import API
import Backport

struct FiltersDisclosure<T: Hashable>: View {
    @EnvironmentObject private var f: FiltersStore
    var tag: (Filter) -> T
    
    var body: some View {
        Memorized(
            filters: f.state.simple(),
            tag: tag
        )
    }
}

extension FiltersDisclosure {
    struct Memorized: View {
        var filters: [Filter]
        var tag: (Filter) -> T

        var body: some View {
            if !filters.isEmpty {
                DisclosureGroup {
                    ForEach(filters) {
                        FilterRow($0)
                            .backport.tag(tag($0))
                    }
                } label: {
                    Label("Filters", systemImage: "circle.grid.2x2")
                }
            }
        }
    }
}

extension FiltersDisclosure where T == Filter {
    init() {
        self.tag = { $0 }
    }
}

extension FiltersDisclosure where T == FindBy {
    init() {
        self.tag = { .init($0) }
    }
}
