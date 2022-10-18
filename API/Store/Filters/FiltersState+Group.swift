import Foundation

extension FiltersState {
    public struct Group: Equatable, Codable {
        static let blank = Self()

        public var simple = [Filter]()
        public var tags = [Filter]()
        public var created = [Filter]()
        public var status = Status.idle
        
        public enum Status: String, Equatable, Codable {
            case idle
            case loading
            case notFound
            case error
        }
    }
}

extension FiltersState {
    public func simple(_ find: FindBy) -> [Filter] {
        self[find].simple
    }
    
    public func tags(_ find: FindBy) -> [Filter] {
        self[find].tags
    }
    
    public func created(_ find: FindBy) -> [Filter] {
        self[find].created
    }
    
    public func status(_ find: FindBy) -> Group.Status {
        self[find].status
    }
    
    //save only valid groups to cache
    static func cachable(_ groups: Groups) -> Groups {
        groups.filter { $0.1.status == .idle }
    }
    
    //access specific group by state[find].ids, etc
    subscript(find: FindBy) -> Group {
        get { groups[find] ?? Group.blank }
        set {
            groups[find] = newValue
        }
    }
}
