import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public extension ProxyRepresentation {
    init(exporting: @escaping @Sendable (Item) async throws -> ProxyRepresentation, backport: @escaping @Sendable (Item) throws -> ProxyRepresentation) {
        if #available(iOS 16.1, macOS 13.1, tvOS 16.1, watchOS 9.1,  *) {
            self.init(exporting: exporting)
        } else {
            self.init(exporting: backport)
        }
    }
}
