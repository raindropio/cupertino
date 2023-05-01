import Foundation
import SwiftUI

public struct RaindropsState: ReduxState {
    typealias Segments = [ FindBy : Segment ]

    @Persisted("rns-items") var items = [ Raindrop.ID: Raindrop ]()
    @Persisted("rns-segments", restore) var segments = Segments()
    @Persisted("rns-suggestions") var suggestions = [ URL: RaindropSuggestions ]()
    public var animation = UUID()

    public init() {}
}

extension RaindropsState {
    public func item(_ id: Raindrop.ID) -> Raindrop? {
        items[id]
    }
    
    public func item(_ url: URL) -> Raindrop? {
        let compact = url.compact
        return items.first {
            $1.link.compact == compact
        }?.value
    }
    
    public func suggestions(_ url: URL) -> RaindropSuggestions {
        suggestions[url.compact] ?? .init()
    }
}
