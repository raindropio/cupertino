import SwiftUI
import API
import UI

//MARK: - Init
public struct SimpleFilters<T: Hashable>: View {
    @EnvironmentObject private var f: FiltersStore
    private var tag: (Filter) -> T
    
    public var body: some View {
        Memorized(
            tag: tag,
            items: f.state.simple()
        )
    }
}

extension SimpleFilters where T == String {
    public init() {
        self.tag = { $0.title }
    }
}

extension SimpleFilters where T == FindBy {
    public init() {
        self.tag = { .init($0) }
    }
}

//MARK: - View
extension SimpleFilters {
    fileprivate struct Memorized: View {
        var tag: (Filter) -> T
        var items: [Filter]
    
        var body: some View {
            ForEach(items) { item in
                FilterRow(item)
                    .tag(tag(item))
            }
        }
    }
}
