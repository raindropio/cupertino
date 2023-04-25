import Foundation
import SwiftUI

public struct RaindropsState: ReduxState {
    typealias Segments = [ FindBy : Segment ]

    @Persisted("rns-items") var items = [ Raindrop.ID: Raindrop ]()
    @Persisted("rns-segments", restore) var segments = Segments()
    @Persisted("rns-links") var lookups = [ URL: Raindrop.ID ]()
    @Persisted("rns-suggestions") var suggestions = [ URL: RaindropSuggestions ]()
    public var animation = UUID()

    public init() {}
}

extension RaindropsState {
    public func item(_ id: Raindrop.ID) -> Raindrop? {
        items[id]
    }
    
    public func item(_ url: URL) -> Raindrop? {
        let id = lookups[url.compact]        
        guard let id else { return nil }
        return items[id]
    }
    
    public func suggestions(_ url: URL) -> RaindropSuggestions {
        suggestions[url.compact] ?? .init()
    }
    
    public func waitLookup(_ url: URL) -> Bool {
        //known id, but no item
        if let id = lookups[url.compact], items[id] == nil {
            return true
        }
        //no lookups
        return lookups.isEmpty
    }
}
