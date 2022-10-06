import SwiftUI

extension NavigationPanes {
    struct Pad: View {
        @Environment(\.horizontalSizeClass) private var sizeClass
        @SceneStorage("navigation-panes-hide-sidebar") private var hideSidebar = false
        
        @Binding var path: P
        var sidebar: () -> S
        var detail: (P.Element?) -> D
        
        var body: some View {
            let layout = sizeClass == .regular ?
                AnyLayout(HStackLayout(alignment: .top, spacing: 0)) :
                AnyLayout(ZStackLayout(alignment: .topLeading))

            GeometryReader { geo in
                layout {
                    if sizeClass == .compact || !hideSidebar {
                        PadSidebar(hideSidebar: $hideSidebar, sidebar: sidebar)
                            .frame(width: sizeClass == .regular ? max(400, geo.size.width * 0.35) : nil)
                            .transition(.move(edge: .leading))
                    }
                    
                    if sizeClass == .regular || !path.isEmpty {
                        PadMain(hideSidebar: $hideSidebar, path: $path, detail: detail)
                            .shadow(color: .secondary.opacity(0.2), radius: 0, x: -0.5)
                            .transition(.move(edge: .trailing))
                    }
                }
                    .modifier(PadFullScreen(path: $path, detail: detail))
            }
                .animation(.default, value: sizeClass == .compact ? path.isEmpty : hideSidebar)
        }
    }
}

//MARK: - Sidebar Content
fileprivate extension NavigationPanes {
    struct PadSidebar: View {
        @Environment(\.horizontalSizeClass) private var sizeClass
        
        @Binding var hideSidebar: Bool
        var sidebar: () -> S

        var body: some View {
            NavigationStack {
                sidebar()
//                    .toolbar {
//                        if sizeClass == .regular {
//                            ToolbarItem(placement: .navigationBarLeading) {
//                                Button {
//                                    hideSidebar = !hideSidebar
//                                } label: {
//                                    Image(systemName: "sidebar.left")
//                                }
//                            }
//                        }
//                    }
            }
        }
    }
}

//MARK: - Main Content
fileprivate extension NavigationPanes {
    struct PadMain: View {
        @Environment(\.horizontalSizeClass) private var sizeClass
        
        @Binding var hideSidebar: Bool
        @Binding var path: P
        var detail: (P.Element?) -> D
        
        private var subPath: Binding<P> {
            .init {
                var part = path.filter { $0.appearance != .fullScreen }
                if !part.isEmpty { part.removeFirst() }
                return part
            } set: { updated in
                path = path.filter { $0.appearance != .fullScreen }[0...0]
                    + updated
                    + path.filter { $0.appearance == .fullScreen }
            }
        }
        
        private var toogleButton: some View {
            Button {
                if sizeClass == .compact {
                    path = .init()
                } else {
                    hideSidebar = !hideSidebar
                }
            } label: {
                Image(systemName: "xmark")
                    .symbolVariant(.circle.fill)
                    .symbolRenderingMode(.hierarchical)
            }
        }
        
        var body: some View {
            NavigationStack(path: subPath) {
                detail(path.first)
                    .toolbar {
                        if sizeClass == .compact || hideSidebar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                toogleButton
                            }
                        }
                    }
                    .navigationDestination(for: P.Element.self, destination: detail)
            }
        }
    }
}

//MARK: - Full Screen Modal
fileprivate extension NavigationPanes {
    struct PadFullScreen: ViewModifier {
        @Binding var path: P
        var detail: (P.Element?) -> D
        
        private var isPresented: Binding<Bool> {
            .init {
                first != nil
            } set: {
                if !$0 { close() }
            }
        }
        
        private var first: P.Element? {
            path.first { $0.appearance == .fullScreen }
        }
        
        private func close() {
            let index = path.firstIndex { $0.appearance == .fullScreen }
            if let index {
                path.remove(at: index)
            }
        }
        
        func body(content: Content) -> some View {
            content.fullScreenCover(isPresented: isPresented) {
                NavigationStack {
                    detail(first)
                        .toolbar {
                            ToolbarItem(placement: .navigation) {
                                Button(action: close) {
                                    Image(systemName: "xmark")
                                        .symbolVariant(.circle.fill)
                                        .symbolRenderingMode(.hierarchical)
                                }
                            }
                        }
                }
            }
        }
    }
}
