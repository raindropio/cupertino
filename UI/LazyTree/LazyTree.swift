import SwiftUI

public struct LazyTree<Element: Identifiable, Leaf: View> {
    var data: [Element]
    var parent: KeyPath<Element, Element.ID?>
    var expanded: KeyPath<Element, Bool>
    var expandable: (Element.ID) -> Bool
    
    //optionals
    public typealias ToggleClosue = ((Element.ID) -> Void)?
    var toggle: ToggleClosue
    
    public typealias ReorderClosue = ((_ ids: [Element.ID], _ parent: Element.ID?, _ order: Int) -> Void)?
    var reorder: ReorderClosue
    
    //rendering
    var leaf: (Element) -> Leaf
    
    public init(
        data: [Element],
        parent: KeyPath<Element, Element.ID?>,
        expanded: KeyPath<Element, Bool>,
        expandable: @escaping (Element.ID) -> Bool,
        toggle: ToggleClosue = nil,
        reorder: ReorderClosue = nil,
        leaf: @escaping (Element) -> Leaf
    ) {
        self.data = data
        self.parent = parent
        self.expanded = expanded
        self.expandable = expandable
        self.toggle = toggle
        self.reorder = reorder
        self.leaf = leaf
    }
}

extension LazyTree {
    func isExpanded(_ element: Element) -> Binding<Bool> {
        .init { element[keyPath: expanded] } set: { _ in
            toggle?(element.id)
        }
    }
    
    //parent: inset
    func insets() -> [Element.ID?: CGFloat] {
        var levels: [Element.ID?: CGFloat] = [nil: 0.0]
        var prev: Element.ID?
        
        data.forEach {
            let parent = $0[keyPath: parent]
            if parent != prev {
                if levels[parent] == nil {
                    levels[parent] = (levels[prev] ?? 0.0) + 1
                }
                prev = parent
            }
        }
        
        return levels
    }
    
    func onMove(_ indices: IndexSet, _ to: Int) {
        guard let reorder else { return }
        
        let ids = indices.map { data[$0].id }
        
        let target: Element? = to < data.count ? data[to] : nil
        let newParent: Element.ID? = target?[keyPath: parent]
        
        let siblings = data.filter { $0[keyPath: parent] == newParent }
        let order: Int = siblings.firstIndex { $0.id == target?.id } ?? siblings.count
        
        reorder(ids, newParent, order)
    }
}

extension LazyTree: View {
    public var body: some View {
        let insets = insets()
        
        ForEach(data) { element in
            Group {
                if expandable(element.id) {
                    DisclosureGroup(isExpanded: isExpanded(element)) {} label: {
                        leaf(element)
                    }
                } else {
                    leaf(element)
                }
            }
                .padding(.leading, (insets[element[keyPath: parent]] ?? 0) * 32)
        }
            .onMove(perform: onMove)
    }
}

extension LazyTree: Equatable where Element: Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.data.hashValue == rhs.data.hashValue
    }
}
