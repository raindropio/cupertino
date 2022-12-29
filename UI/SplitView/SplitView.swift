import SwiftUI

public struct SplitView<P: Hashable, S: View, D: View> {
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    @Binding var path: [P]
    var master: () -> S
    var detail: (P) -> D
    
    public init(
        path: Binding<[P]>,
        master: @escaping () -> S,
        @ViewBuilder detail: @escaping (P) -> D
    ) {
        self._path = path
        self.master = master
        self.detail = detail
    }
}

extension SplitView: View {
    public var body: some View {
        Group {
            if isPhone {
                Compact(path: $path, master: master, detail: detail)
            } else {
                Regular(path: $path, master: master, detail: detail)
            }
        }
            .environment(\.splitViewSizeClass, sizeClass)
    }
}
