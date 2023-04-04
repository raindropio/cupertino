import SwiftUI

public struct LazyTree<I: Identifiable & Equatable, C: View, T: Hashable> {
    //data
    var root: [I.ID]
    var items: [I.ID: I]
    
    //key path's
    var parent: KeyPath<I, I.ID?>
    var expanded: KeyPath<I, Bool>
    var sort: KeyPath<I, Int?>
    
    //actions
    public typealias ToggleClosue = (I.ID) -> Void
    var toggle: ToggleClosue
    
    public typealias ReorderClosue = (_ ids: [I.ID], _ parent: I.ID?, _ order: Int) -> Void
    var reorder: ReorderClosue
    
    //content
    var tag: (I.ID) -> T
    var content: (I) -> C
    
    public init(
        root: [I.ID],
        items: [I.ID : I],
        parent: KeyPath<I, I.ID?>,
        expanded: KeyPath<I, Bool>,
        sort: KeyPath<I, Int?>,
        toggle: @escaping ToggleClosue,
        reorder: @escaping ReorderClosue,
        tag: @escaping (I.ID) -> T,
        content: @escaping (I) -> C
    ) {
        self.root = root
        self.items = items
        self.parent = parent
        self.expanded = expanded
        self.sort = sort
        self.toggle = toggle
        self.reorder = reorder
        self.tag = tag
        self.content = content
    }
}

extension LazyTree where T == I.ID {
    public init(
        root: [I.ID],
        items: [I.ID : I],
        parent: KeyPath<I, I.ID?>,
        expanded: KeyPath<I, Bool>,
        sort: KeyPath<I, Int?>,
        toggle: @escaping ToggleClosue,
        reorder: @escaping ReorderClosue,
        content: @escaping (I) -> C
    ) {
        self.root = root
        self.items = items
        self.parent = parent
        self.expanded = expanded
        self.sort = sort
        self.toggle = toggle
        self.reorder = reorder
        self.tag = { $0 }
        self.content = content
    }
}

extension LazyTree {
    struct Leaf: Identifiable {
        var id: I.ID
        var expanded: Bool?
        var level: Double = 0
    }
}

extension LazyTree {
    func tree() -> [Leaf] {
        root
            .compactMap { items[$0] }
            .flatMap { branch($0) }
    }
    
    func branch(_ item: I, level: Double = 0) -> [Leaf] {
        let expandable = expandable(item.id)
        
        return [.init(
            id: item.id,
            expanded: expandable ? item[keyPath: expanded] : nil,
            level: level
        )] + (
            expandable && item[keyPath: expanded] ?
                childrens(item.id, level: level+1)
            : []
        )
    }
    
    func expandable(_ parentId: I.ID) -> Bool {
        items.first { $0.value[keyPath: parent] == parentId } != nil
    }
    
    func childrens(_ parentId: I.ID, level: Double) -> [Leaf] {
        items
            .filter { $0.value[keyPath: parent] == parentId }
            .sorted(by: { ($0.value[keyPath: sort] ?? 0) < ($1.value[keyPath: sort] ?? 0) })
            .flatMap { branch($0.value, level: level) }
    }
}

extension LazyTree {
    func onMove(_ indices: IndexSet, _ to: Int) {
        let tree = tree()
        let ids = indices.map { tree[$0].id }
        
        let target: I? = to < tree.count ? items[tree[to].id] : nil
        let newParent: I.ID? = target?[keyPath: parent]
                
        let siblings = tree
            .filter { items[$0.id]?[keyPath: parent] == newParent }
            .filter { !ids.contains($0.id) }
            
        let order: Int = siblings.firstIndex { $0.id == target?.id } ?? siblings.count
        
        reorder(ids, newParent, order)
    }
}

extension LazyTree: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.root == rhs.root &&
        lhs.items == rhs.items
    }
}

extension LazyTree: View {
    public var body: some View {
        let tree = tree()
        
        ForEach(tree) {
            LazyTreeItem($0, expanded: \.expanded, toggle: toggle) {
                content(items[$0.id]!)
            }
                #if canImport(UIKit)
                .padding(.leading, $0.level * 32)
                #else
                .padding(.leading, $0.level * 16)
                #endif
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .tag(tag($0.id))
        }
            .onMove(perform: onMove)
    }
}
