import SwiftUI

struct LazyTreeItem<I: Identifiable, L: View> {
    var item: I
    var expanded: KeyPath<I, Bool?>
    var toggle: (I.ID) -> Void
    var label: (I) -> L
    
    init(
        _ item: I,
        expanded: KeyPath<I, Bool?>,
        toggle: @escaping (I.ID) -> Void,
        label: @escaping (I) -> L
    ) {
        self.item = item
        self.expanded = expanded
        self.toggle = toggle
        self.label = label
    }
    
    private func pressToggle() {
        toggle(item.id)
    }
}

extension LazyTreeItem: View {
    var body: some View {
        HStack(spacing: 12) {
            label(item)
            
            if let expanded = item[keyPath: expanded] {
                Button(action: pressToggle) {
                    Image(systemName: "chevron.down")
                        .fontWeight(.medium)
                        .imageScale(.medium)
                        .rotationEffect(.degrees(expanded ? 0 : -90))
                }
                    #if os(visionOS)
                    .buttonStyle(.plain)
                    #else
                    .buttonStyle(.borderless)
                    #endif
            }
        }
    }
}
