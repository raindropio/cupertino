import SwiftUI

public struct SafariLink<L: View> {
    @State private var show = false
    @Environment(\.openURL) private var openURL
    
    var destination: URL
    var label: () -> L
    
    public init(destination: URL, label: @escaping () -> L) {
        self.destination = destination
        self.label = label
    }
}

extension SafariLink where L == Text {
    public init<S: StringProtocol>(_ title: S, destination: URL) {
        self.destination = destination
        self.label = { Text(title) }
    }
}

#if canImport(UIKit)
extension SafariLink: View {
    private func press() {
        show.toggle()
    }
    
    public var body: some View {
        Button(action: press, label: label)
            .safariView(isPresented: $show, url: destination)
    }
}
#else
extension SafariLink: View {
    public var body: some View {
        Button(action: { openURL(destination) }, label: label)
    }
}
#endif
