import SwiftUI

public struct SuperTabView<SelectionValue: Hashable, Content: View> {
    @Binding var selection: SelectionValue
    var content: () -> Content
    
    @State private var controller: UITabBarController?
    @State private var prevSelection: SelectionValue?
    
    public init(selection: Binding<SelectionValue>, @ViewBuilder content: @escaping () -> Content) {
        self._selection = selection
        self.content = content
    }
    
    //optionals
    private var tabAction: ((SelectionValue) -> Bool)?
    public func tabAction(_ action: @escaping (SelectionValue) -> Bool) -> Self {
        var copy = self; copy.tabAction = action; return copy
    }
}

extension SuperTabView {
    private func popToRoot() {
        guard let nav = (
            (controller?.selectedViewController?.children.first as? UISplitViewController)?.viewControllers.first ??
            controller?.selectedViewController?.children.first
        ) as? UINavigationController else { return }
        nav.popToRootViewController(animated: true)
    }
}

extension SuperTabView: View {
    public var body: some View {
        TabView(selection: .init(
            get: { selection },
            set: {
                if selection == $0 {
                    popToRoot()
                } else {
                    selection = $0
                }
            }
        )) {
            content()
                .toolbarBackground(.bar, for: .tabBar)
                .withTabBarController($controller)
        }
            .onAppear {
                prevSelection = selection
            }
            .onChange(of: selection) { selected in
                if let tabAction, let prevSelection, tabAction(selected) {
                    selection = prevSelection
                } else {
                    prevSelection = selection
                }
            }
    }
}
