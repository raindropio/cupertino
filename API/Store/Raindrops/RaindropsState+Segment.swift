import Foundation

extension RaindropsState {
    public struct Segment: Equatable, Codable {
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
        
        mutating func validMore() {
            more = ids.count >= total ? .notFound : .idle
        }
    }
}

extension RaindropsState {
    public func ids(_ find: FindBy) -> [Raindrop.ID] {
        self[find].ids
    }
    
    public func items(_ find: FindBy) -> [Raindrop] {
        self[find].ids.compactMap { items[$0] }
    }
    
    public func status(_ find: FindBy) -> Segment.Status {
        segments[find] != nil ? self[find].status : .loading
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
    static func restore(_ segments: Segments) -> Segments {
        segments.filter {
            $0.1.status == .idle && ($0.1.more == .idle || $0.1.more == .notFound)
        }
    }
    
    //access specific group by state[find].ids, etc
    subscript(find: FindBy) -> Segment {
        get { segments[find] ?? .init() }
        set {
            segments[find] = newValue
        }
    }
}
