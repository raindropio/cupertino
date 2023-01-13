import SwiftUI
import API
import UI

public struct RaindropTitleExcerpt: View {
    var raindrop: Raindrop
    
    public init(_ raindrop: Raindrop) {
        self.raindrop = raindrop
    }
    
    public var body: some View {
        Text(raindrop.title)
            .fontWeight(.semibold)
        
        if !raindrop.excerpt.isEmpty {
            Text(raindrop.excerpt)
        }
    }
}
