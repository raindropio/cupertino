import SwiftUI
import API
import UI

public struct RaindropTitleExcerpt: View {
    @Environment(\.raindropsContainer) private var container
    var raindrop: Raindrop
    
    public init(_ raindrop: Raindrop) {
        self.raindrop = raindrop
    }
    
    public var body: some View {
        Group {
            if container?.hide.contains(.title) != true {
                Text(raindrop.title)
                    .fontWeight(.semibold)
            }
            
            if !raindrop.excerpt.isEmpty, container?.hide.contains(.excerpt) != true {
                Text(raindrop.excerpt)
                    .font(.callout)
            }
        }
            .fixedSize(horizontal: false, vertical: true)
            .contentTransition(.opacity)
    }
}
