import SwiftUI

public struct NavigationPanes<P: MutableCollection, S: View, D: View> where P: RandomAccessCollection & RangeReplaceableCollection & Equatable, P.Element: NavigationPane {
    @Binding var path: P
    var sidebar: () -> S
    var detail: (P.Element?) -> D
    
    public init(
        path: Binding<P>,
        sidebar: @escaping () -> S,
        @ViewBuilder detail: @escaping (P.Element?) -> D
    ) {
        self._path = path
        self.sidebar = sidebar
        self.detail = detail
    }
}

extension NavigationPanes: View {
    public var body: some View {
        if isPhone {
            Phone(path: $path, sidebar: sidebar, detail: detail)
        } else {
            Pad(path: $path, sidebar: sidebar, detail: detail)
        }
    }
}
