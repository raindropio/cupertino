import SwiftUI

public extension View {
    func openLinksInSafari() -> some View {
        #if canImport(UIKit)
        modifier(OLIS())
        #else
        self
        #endif
    }
}

#if os(iOS)
fileprivate struct OLIS: ViewModifier {
    @State private var url: URL?
    
    func body(content: Content) -> some View {
        content
            .environment(\.openURL, .init { url = $0; return .handled })
            .safariView(item: $url)
    }
}
#else
fileprivate struct OLIS: ViewModifier {
    @Environment(\.openURL) private var openURL
    @State private var url: URL?

    func body(content: Content) -> some View {
        content
            .environment(\.openURL, .init { openURL($0); return .handled })
    }
}
#endif
