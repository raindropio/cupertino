import Foundation

public struct CGroup: Identifiable {
    public var id: String { "g\(sort)" }
    public var title: String
    public var hidden = false
    public var sort = 0
    public var collections: [Collection.ID] = []
}

extension CGroup: Equatable {
    public static func ==(l: Self, r: Self) -> Bool {
        l.id == r.id &&
        l.title == r.title &&
        l.sort == r.sort &&
        l.collections == r.collections
    }
}
