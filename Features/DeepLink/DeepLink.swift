import SwiftUI

public struct DeepLink<L: View>: View {
    @Environment(\.openDeepLink) private var openDeepLink
    
    var destination: DeepLinkDestination
    var label: () -> L
    
    public init(_ destination: DeepLinkDestination, label: @escaping () -> L) {
        self.destination = destination
        self.label = label
    }
    
    public var body: some View {
        Button(action: {
            openDeepLink?(destination)
        }, label: label)
    }
}
