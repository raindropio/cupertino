import SwiftUI
import API
import UI

struct FindTags<T: Hashable>: View {
    @EnvironmentObject private var f: FiltersStore
    var search: String
    var tag: (Filter) -> T

    var body: some View {
        Memorized(
            tags: f.state.completion(.init(search))
                .filter {
                    if case .tag(_) = $0.kind {
                        return true
                    } else {
                        return false
                    }
                },
            tag: tag
        )
    }
}

extension FindTags {
    fileprivate struct Memorized: View {
        var tags: [Filter]
        var tag: (Filter) -> T

        var body: some View {
            Section {
                if !tags.isEmpty {
                    ForEach(tags) { item in
                        FilterRow(item)
                            .backport.tag(tag(item))
                    }
                }
            } header: {
                if !tags.isEmpty {
                    Text("Found \(tags.count) tags")
                }
            }
        }
    }
}

extension FindTags where T == Filter {
    init(_ search: String) {
        self.search = search
        self.tag = { $0 }
    }
}

extension FindTags where T == FindBy {
    init(_ search: String) {
        self.search = search
        self.tag = { .init($0) }
    }
}
