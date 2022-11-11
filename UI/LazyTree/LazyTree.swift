import SwiftUI

public struct LazyTree<I: Identifiable & Equatable, C: View> {
    //data
    var root: [I.ID]
    var items: [I.ID: I]
    
    //key path's
    var parent: KeyPath<I, I.ID?>
    var expanded: KeyPath<I, Bool>
    var sort: KeyPath<I, Int>
    
    //actions
    public typealias ToggleClosue = (I.ID) -> Void
    var toggle: ToggleClosue
    
    public typealias ReorderClosue = (_ ids: [I.ID], _ parent: I.ID?, _ order: Int) -> Void
    var reorder: ReorderClosue
    
    //content
    var content: (I) -> C
    
    public init(
        root: [I.ID],
        items: [I.ID : I],
        parent: KeyPath<I, I.ID?>,
        expanded: KeyPath<I, Bool>,
        sort: KeyPath<I, Int>,
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
        self.content = content
    }
}

extension LazyTree {
    struct Leaf: Identifiable {
        var id: I.ID
        var expandable: Bool = false
        var level: Double = 0
    }
}

extension LazyTree {
    var tree: [Leaf] {
        root
            .compactMap { items[$0] }
            .flatMap { branch($0) }
    }
    
    func branch(_ item: I, level: Double = 0) -> [Leaf] {
        let more = childrens(item.id, level: level+1)
        
        return [.init(
            id: item.id,
            expandable: !more.isEmpty,
            level: level
        )] + (item[keyPath: expanded] ? more : [])
    }
    
    func childrens(_ parentId: I.ID, level: Double) -> [Leaf] {
        items
            .filter { $0.value[keyPath: parent] == parentId }
            .sorted(by: { $0.value[keyPath: sort] < $1.value[keyPath: sort] })
            .flatMap { branch($0.value, level: level) }
    }
}

extension LazyTree {
    func isExpanded(_ id: I.ID) -> Binding<Bool> {
        .init { items[id]?[keyPath: expanded] ?? false } set: { _ in
            toggle(id)
        }
    }
    
    func onMove(_ indices: IndexSet, _ to: Int) {
        let tree = tree
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
        ForEach(tree) { leaf in
            Group {
                if leaf.expandable {
                    DisclosureGroup(isExpanded: isExpanded(leaf.id)) {} label: {
                        content(items[leaf.id]!)
                    }
                } else {
                    content(items[leaf.id]!)
                }
            }
                .padding(.leading, leaf.level * 32)
                .transition(.move(edge: .bottom))
        }
            .onMove { onMove($0, $1) }
    }
}
