import SwiftUI

@available(iOS, deprecated: 16.0)
public extension Backport where Wrapped == Any {
    @ViewBuilder
    static func NavigationStack<C: View>(root: @escaping () -> C) -> some View {
        if #available(iOS 16, *) {
            SwiftUI.NavigationStack(root: root)
        } else {
            NoPath(root: root)
        }
    }
    
    @ViewBuilder
    static func NavigationStack<P: Hashable, C: View>(path: Binding<[P]>, root: @escaping () -> C) -> some View {
        if #available(iOS 16, *) {
            SwiftUI.NavigationStack(path: path, root: root)
        } else {
            WithPath(path: path, root: root)
        }
    }
}

fileprivate struct NoPath<C: View>: View {
    var root: () -> C

    var body: some View {
        SwiftUI.NavigationView(content: root)
            .navigationViewStyle(.stack)
    }
}

fileprivate struct WithPath<P: Hashable, C: View>: View {
    @StateObject private var service = BackportNavigationService<P>()
    
    @Binding var path: [P]
    var root: () -> C

    var body: some View {
        SwiftUI.NavigationView(content: root)
            .navigationViewStyle(.stack)
            .task(id: path) { service.path = path }
            .task(id: service.path) { path = service.path }
            .environmentObject(service)
    }
}

class BackportNavigationService<P: Hashable>: ObservableObject {
    @Published var path: [P] = []
}
