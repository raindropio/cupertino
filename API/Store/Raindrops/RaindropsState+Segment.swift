import Foundation

extension RaindropsState {
    public struct Segment: Equatable, Codable {
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
}

extension RaindropsState {
    public func items(_ find: FindBy) -> [Raindrop] {
        self[find].ids.compactMap { items[$0] }
    }
    
    public func status(_ find: FindBy) -> Segment.Status {
        self[find].status
    }
    
    //save only valid groups to cache
    static func cachable(_ segments: Segments) -> Segments {
        segments.filter {
            $0.1.status == .idle && ($0.1.more == .idle || $0.1.more == .end)
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
