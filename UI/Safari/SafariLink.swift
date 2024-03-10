import SwiftUI

public struct SafariLink<L: View> {
    @State private var show = false
    @Environment(\.openURL) private var openURL
    
    var destination: URL
    var role: ButtonRole?
    var label: () -> L
    
    public init(role: ButtonRole? = nil, destination: URL, label: @escaping () -> L) {
        self.role = role
        self.destination = destination
        self.label = label
    }
}

extension SafariLink where L == Text {
    public init<S: StringProtocol>(_ title: S, role: ButtonRole? = nil, destination: URL) {
        self.role = role
        self.destination = destination
        self.label = { Text(title) }
    }
}

#if os(iOS)
extension SafariLink: View {
    private func press() {
        show.toggle()
    }
    
    public var body: some View {
        Button(role: role, action: press, label: label)
            .safariView(isPresented: $show, url: destination)
    }
}
#else
extension SafariLink: View {
    public var body: some View {
        Button(role: role, action: { openURL(destination) }, label: label)
    }
}
#endif
