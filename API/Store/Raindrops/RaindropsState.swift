import Foundation
import SwiftUI

public struct RaindropsState: ReduxState {
    typealias Segments = [ FindBy : Segment ]

    @Cached("rns-items") var items = [Raindrop.ID: Raindrop]()
    @Cached("rns-segments", restore) var segments = Segments()
    public var animation = UUID()

    public init() {}
}

extension RaindropsState {
    public func item(_ id: Raindrop.ID) -> Raindrop? {
        items[id]
    }
    
    public func item(_ url: URL) -> Raindrop? {
        items.first {
            $0.value.link == url
        }.map {
            $0.value
        }
    }
}
