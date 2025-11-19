import SwiftUI
import ObjectiveC

public struct Backported<Wrapped> {
    public let content: Wrapped
    public init(_ content: Wrapped) { self.content = content }
}

public extension View {
    var backport: Backported<Self> { .init(self) }
}

public extension ToolbarContent {
    var backport: Backported<Self> { .init(self) }
}

public enum Backport {}

public extension NSObjectProtocol {
    var backport: Backported<Self> { .init(self) }
}
