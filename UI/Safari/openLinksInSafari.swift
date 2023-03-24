import SwiftUI

public extension View {
    func openLinksInSafari() -> some View {
        modifier(OLIS())
    }
}

fileprivate struct OLIS: ViewModifier {
    @State private var url: URL?
    
    func body(content: Content) -> some View {
        content
            .environment(\.openURL, .init { url = $0; return .handled })
            .safariView(item: $url)
    }
}
