import SwiftUI

public struct Filter: Hashable, Equatable, Codable {
    public var kind: Kind
    public var count: Int = 0
    public var exclude = false
    
    public init(_ kind: Kind, count: Int = 0, exclude: Bool = false) {
        self.kind = kind
        self.count = count
        self.exclude = exclude
    }

    public var title: String { "\(exclude ? "Not ": "")\(kind.title)" }
    public var systemImage: String { kind.systemImage }
    public var color: Color { kind.color }
}

extension Filter: Identifiable {
    public var id: String { description }
}

//string convertible
extension Filter: CustomStringConvertible {
    public var description: String { "\(exclude ? "-" : "")\(kind)" }
}

extension Filter {
    public func contains(_ text: String) -> Bool {
        title.localizedLowercase.contains(text.localizedLowercase.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    public func excluding(_ exclude: Bool = true) -> Self {
        var copy = self
        copy.exclude = exclude
        return copy
    }
}
