import SwiftUI

extension FakeListForEach {
    struct Element: View {
        let item: Item
        public let content: (_ item: Item) -> Content
        
        @State private var highlighted = false
        @Environment(\.fakeListStyle) private var style
        @Environment(\.fakeListSelection) private var selection
        @Environment(\.itemAction) private var itemAction
        @Environment(\.editMode) private var editMode
        
        var body: some View {
            let selected = highlighted || selection.wrappedValue.contains(item.id)
            let editing = editMode?.wrappedValue == .active
            
            content(item)
                .background(
                    selected ?
                        style.itemSelectedBackground :
                        style.itemNormalBackground
                )
                .opacity(!selected && editing ? 0.7 : 1)
                ._onButtonGesture { highlighted = $0 } perform: {
                    if editing {
                        if selection.wrappedValue.contains(item.id) {
                            selection.wrappedValue.remove(item.id)
                        } else {
                            _ = selection.wrappedValue.insert(item.id)
                        }
                    } else {
                        selection.wrappedValue = []
                        itemAction?([item.id])
                    }
                }
        }
    }
}
