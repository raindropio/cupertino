import Foundation
import SwiftUI

public struct RaindropsState: ReduxState {
    typealias Segments = [ FindBy : Segment ]

    @Cached("rns-items") var items = [Raindrop.ID: Raindrop]()
    @Cached("rns-segments", restore) var segments = Segments()
    
    public init() {}
}

extension RaindropsState {
    public func item(_ id: Raindrop.ID) -> Raindrop? {
        items[id]
    }
}
