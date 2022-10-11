import Foundation

public struct RaindropsState {
    private var elements = [ Raindrop.ID : Raindrop ]()
    private var spaces = [ FindBy : [ SortBy : Space ] ]()
    
    public func items(_ find: FindBy, _ sort: SortBy) -> [Raindrop] {
        getSpace(find, sort).ids.compactMap {
            elements[$0]
        }
    }
    
    public func status(_ find: FindBy, _ sort: SortBy) -> Space.Status {
        getSpace(find, sort).status
    }
}

//Space
extension RaindropsState {
    private static let blankSpace = Space()
    
    private func getSpace(_ find: FindBy, _ sort: SortBy) -> Space {
        spaces[find]?[sort] ?? Self.blankSpace
    }
    
    public struct Space {
        public var ids = [Raindrop.ID]()
        public var status = Status()
        
        public struct Status {
            public var main = Variants.idle
            public var nextPage = Variants.idle
            
            public enum Variants {
                case idle, empty, loading, error(Error)
            }
        }
    }
}
