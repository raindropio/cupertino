import SwiftUI

public struct Filter: Hashable, Equatable, Codable {
    public var kind: Kind
    public var count: Int = 0
    
    public init(_ kind: Kind, count: Int = 0) {
        self.kind = kind
        self.count = 0
    }

    public var title: String { kind.title }
    public var systemImage: String { kind.systemImage }
    public var color: Color { kind.color }
}

extension Filter: Identifiable {
    public var id: String { description }
}

//string convertible
extension Filter: CustomStringConvertible {
    public var description: String { "\(kind)" }
}
