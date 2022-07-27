import SwiftUI

struct FakeList<SelectionValue: Hashable, Content: View> {
    @Binding var selection: Set<SelectionValue>
    var style = FakeListStyle.plain
    @ViewBuilder var content: () -> Content
    
    @Environment(\.editMode) private var editMode
    
    init(selection: Binding<Set<SelectionValue>>, @ViewBuilder content: @escaping () -> Content) {
        self._selection = selection
        self.content = content
    }
    
    //optionals
    func listStyle(_ style: FakeListStyle) -> Self {
        var copy = self; copy.style = style; return copy
    }
}

extension FakeList: View {
    var body: some View {
        ScrollView(.vertical, content: content)
            .environment(\.fakeListStyle, style)
            .environment(\.fakeListSelection, fakeListSelection())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(style.scrollContentBackground?.ignoresSafeArea())
            //reset selection on edit mode exit
            .onChange(of: editMode?.wrappedValue) {
                if $0 == .inactive {
                    selection = .init()
                }
            }
    }
}
