import SwiftUI

public struct FlatOutlineGroup<Element: Identifiable, Leaf: View> {
    var data: [Element]
    var parent: KeyPath<Element, Element.ID?>
    var expanded: KeyPath<Element, Bool>
    var leaf: (Element) -> Leaf
        
    public init(
        _ data: [Element],
        parent: KeyPath<Element, Element.ID?>,
        expanded: KeyPath<Element, Bool>,
        leaf: @escaping (Element) -> Leaf
    ) {
        self.data = data
        self.parent = parent
        self.expanded = expanded
        self.leaf = leaf
    }
    
    //optionals
    var onToggle: ((Element.ID) -> Void)?
    public func onToggle(_ action: ((_ id: Element.ID) -> Void)?) -> Self {
        var copy = self; copy.onToggle = action; return copy
    }
    
    var onMoveItem: (([Element.ID], Element.ID?, Int) -> Void)?
    public func onMove(_ action: ((_ ids: [Element.ID], _ parent: Element.ID?, _ order: Int) -> Void)?) -> Self {
        var copy = self; copy.onMoveItem = action; return copy
    }
    
    var onMoveIndex: ((IndexSet, Int) -> Void)?
    public func onMove(_ action: ((_ indexSet: IndexSet, _ order: Int) -> Void)?) -> Self {
        var copy = self; copy.onMoveIndex = action; return copy
    }
}

//Updates only when data change
extension FlatOutlineGroup: Equatable where Element: Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.data.hashValue == rhs.data.hashValue
    }
}

extension FlatOutlineGroup: View {
    var rows: [Row] {
        var rows = [Row]()
        
        //indices of root and child elements
        var roots = [Int]()
        var relation = [Element.ID : [Int]]()
        data.indices.forEach {
            if let parent = data[$0][keyPath: parent] {
                relation[parent] = relation[parent] ?? []
                relation[parent]?.append($0)
            } else {
                roots.append($0)
            }
        }
        
        func branch(_ root: Int, level: CGFloat = 0) {
            let id = data[root].id
            let childrens = relation[id]
            let expanded = data[root][keyPath: expanded]
            
            rows.append(
                .init(
                    id: id,
                    index: root,
                    inset: .init(top: 0, leading: 16 + level * 24, bottom: 0, trailing: 16),
                    expandable: childrens != nil,
                    isExpanded: .init { expanded } set: { _ in
                        onToggle?(id)
                    }
                )
            )
            
            if expanded {
                childrens?.forEach {
                    branch($0, level: level + 1)
                }
            }
        }
        
        roots.forEach {
            branch($0)
        }
        
        return rows
    }
    
    func onRowsMove(_ indices: IndexSet, _ to: Int) {
        let rows = rows
        
        if let onMoveItem {
            let ids = indices.map { rows[$0].id }
            
            let target: Element? = to < rows.count ? data[rows[to].index] : nil
            let newParent: Element.ID? = target?[keyPath: parent]
            
            let siblings = data.filter { $0[keyPath: parent] == newParent }
            let order: Int = siblings.firstIndex { $0.id == target?.id } ?? siblings.count
            
            onMoveItem(ids, newParent, order)
        }
        
        if let onMoveIndex {
            onMoveIndex(
                .init(indices.compactMap { rows[$0].index }),
                to < rows.count ? rows[to].index : data.count
            )
        }
    }
    
    public var body: some View {
        ForEach(rows) { row in
            Group {
                if row.expandable {
                    DisclosureGroup(
                        isExpanded: row.isExpanded
                    ) {} label: {
                        leaf(data[row.index])
                    }
                } else {
                    leaf(data[row.index])
                }
            }
                .listRowInsets(row.inset)
        }
            .onMove(perform: onRowsMove)
    }
}

extension FlatOutlineGroup {
    struct Row: Identifiable {
        var id: Element.ID
        var index: Int
        var inset: EdgeInsets
        var expandable: Bool = false
        var isExpanded: Binding<Bool>
    }
}
