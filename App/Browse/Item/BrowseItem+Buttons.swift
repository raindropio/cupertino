import SwiftUI
import API
import UI

extension BrowseItem {
    struct Buttons: View {
        private static let verticalGap: Double = {
            if #available(iOS 16, *) {
                return 4
            } else {
                return 0
            }
        }()
        
        var raindrop: Raindrop
        
        var body: some View {
            if raindrop.important || raindrop.broken || raindrop.duplicate != nil || !raindrop.tags.isEmpty {
                WStack(spacingX: 8, spacingY: 8) {
                    if raindrop.important {
                        FilterButton(kind: .important)
                            .buttonStyle(.borderedProminent)
                    }
                    
                    if raindrop.broken {
                        FilterButton(kind: .broken)
                    }
                    
                    if let original = raindrop.duplicate {
                        FilterButton(kind: .duplicate(of: original))
                    }
                    
                    ForEach(raindrop.tags, id: \.self) { tag in
                        FilterButton(kind: .tag(tag))
                    }
                    .labelStyle(.titleOnly)
                }
                    .buttonStyle(.bordered)
                    .labelStyle(.iconOnly)
                    .controlSize(.small)
                    .padding(.vertical, Self.verticalGap)
            }
        }
    }
}
