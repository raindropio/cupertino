import SwiftUI

public extension View {
    func onDeepLink(perform: @escaping (DeepLinkDestination) -> Void) -> some View {
        modifier(_Modifier(perform: perform))
    }
}

fileprivate struct _Modifier: ViewModifier {
    @State private var openDeepLink = OpenDeepLinkAction()
    
    var perform: (DeepLinkDestination) -> Void
    
    func body(content: Content) -> some View {
        content
            .environment(\.openDeepLink, openDeepLink)
            .onReceive(openDeepLink.publisher, perform: perform)
    }
}
