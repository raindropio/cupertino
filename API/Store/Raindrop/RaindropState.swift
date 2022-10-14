import Foundation
import SwiftUI

public struct RaindropState: Equatable {
    //items
    @Cached("raindrop-state-items")
    var items = [Raindrop.ID: Raindrop]()
    
    //groups
    typealias Groups = [ FindBy : [ SortBy: Group ] ]
    @Cached("raindrop-state-groups", validGroups)
    private var groups = Groups()
}

//MARK: - Group specific
extension RaindropState {
    public struct Group: Equatable, Codable {
        static let blank = Self()

        public var ids = [Raindrop.ID]()
        public var status = Status.idle
        public var more = More.idle
        
        public enum Status: String, Equatable, Codable {
            case idle
            case loading
            case notFound
            case error
        }
        
        public enum More: String, Equatable, Codable {
            case idle
            case loading
            case end
            case error
        }
    }
    
    public func items(_ find: FindBy, _ sort: SortBy) -> [Raindrop] {
        self[find, sort].ids.compactMap { items[$0] }
    }
    
    //access specific group by state[find, sort].ids, etc
    public subscript(find: FindBy, sort: SortBy) -> Group {
        get { groups[find]?[sort] ?? Group.blank }
        set {
            groups[find] = groups[find] ?? .init()
            groups[find]?[sort] = newValue
        }
    }
    
    private static func validGroups(_ groups: Groups) -> Groups {
        var filtered = Groups()
        for (find, nested) in groups {
            for (sort, group) in nested {
                if group.status != .error, group.more != .error {
                    filtered[find] = filtered[find] ?? .init()
                    filtered[find]?[sort] = group
                }
            }
        }
        return filtered
    }
}
