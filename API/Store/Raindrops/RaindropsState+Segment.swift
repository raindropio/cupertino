import Foundation

extension RaindropsState {
    public struct Segment: Equatable, Codable {
        static let blank = Self()

        public var ids = [Raindrop.ID]()
        public var sort = SortBy.sort
        public var page = 0
        
        public var status = Status.idle
        public var more = Status.idle
        public var total = 0
        
        public enum Status: String, Equatable, Codable {
            case idle
            case loading
            case notFound
            case error
        }
    }
}

extension RaindropsState {
    public func items(_ find: FindBy) -> [Raindrop] {
        self[find].ids.compactMap { items[$0] }
    }
    
    public func status(_ find: FindBy) -> Segment.Status {
        self[find].status
    }
    
    public func more(_ find: FindBy) -> Segment.Status {
        self[find].more
    }
    
    public func sort(_ find: FindBy) -> SortBy {
        self[find].sort
    }
    
    public func total(_ find: FindBy) -> Int {
        self[find].total
    }
    
    public func isEmpty(_ find: FindBy) -> Bool {
        self[find].ids.isEmpty
    }
    
    public func exists(_ find: FindBy) -> Bool {
        segments[find] != nil
    }
    
    //save only valid groups to cache
    static func cachable(_ segments: Segments) -> Segments {
        segments.filter {
            $0.1.status == .idle && ($0.1.more == .idle || $0.1.more == .notFound)
        }
    }
    
    //access specific group by state[find].ids, etc
    subscript(find: FindBy) -> Segment {
        get { segments[find] ?? Segment.blank }
        set {
            segments[find] = newValue
        }
    }
}
