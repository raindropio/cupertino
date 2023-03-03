import SwiftUI
import API
import UI

//MARK: - Init
public struct AllTags<T: Hashable>: View {
    @EnvironmentObject private var f: FiltersStore
    private var tag: (Filter) -> T

    var search: String = ""
    
    public var body: some View {
        Memorized(
            tag: tag,
            items: f.state.tags(search)
        )
    }
}

extension AllTags where T == String {
    public init() {
        self.tag = { $0.title }
    }
}

extension AllTags where T == FindBy {
    public init() {
        self.tag = { .init($0) }
    }
    
    public init(search: String) {
        self.search = search
        self.tag = { .init($0) }
    }
}

//MARK: - View
extension AllTags {
    fileprivate struct Memorized: View {
        var tag: (Filter) -> T
        var items: [Filter]
    
        var body: some View {
            ForEach(items) { item in
                FilterRow(item)
                    .swipeActions {
                        TagsMenu(item)
                    }
                    .tag(tag(item))
            }
        }
    }
}
