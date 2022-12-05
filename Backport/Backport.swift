import SwiftUI
import ObjectiveC

public struct Backport<Wrapped> {
    public let content: Wrapped

    public init(_ content: Wrapped) {
        self.content = content
    }
}

public extension View {
    var backport: Backport<Self> { .init(self) }
}

public extension NSObjectProtocol {
    var backport: Backport<Self> { .init(self) }
}
