import SwiftUI
import API
import UI
import Backport

//MARK: - Init
public struct Tags<T: Hashable>: View {
    @EnvironmentObject private var f: FiltersStore
    private var tag: (Filter) -> T

    var find: FindBy
    
    public var body: some View {
        Memorized(
            tag: tag,
            items: f.state.tags(find)
        )
    }
}

extension Tags where T == Filter {
    public init(find: FindBy = .init()) {
        self.find = find
        self.tag = { $0 }
    }
}

extension Tags where T == String {
    public init(find: FindBy = .init()) {
        self.find = find
        self.tag = { $0.title }
    }
}

extension Tags where T == FindBy {
    public init(find: FindBy = .init()) {
        self.find = find
        self.tag = { .init($0) }
    }
    
    public init(search: String) {
        self.find = .init(search)
        self.tag = { .init($0) }
    }
}

//MARK: - View
extension Tags {
    fileprivate struct Memorized: View {
        var tag: (Filter) -> T
        var items: [Filter]
    
        var body: some View {
            if !items.isEmpty {
                ForEach(items) { item in
                    FilterRow(item)
                        .swipeActions {
                            TagsMenu(Set([item]))
                        }
                        .backport.tag(tag(item))
                }
            }
        }
    }
}
