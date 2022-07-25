#if os(macOS)
import SwiftUI
import AppKit

func CVLayout(_ style: CollectionViewStyle) -> NSCollectionViewLayout {
    var layout: NSCollectionViewCompositionalLayout!
    
    layout = NSCollectionViewCompositionalLayout{ sectionIndex, environment in
        switch style {
        case .list(let estimatedHeight):
            return CVListSection(estimatedHeight, environment: environment)
            
        case .grid(let estimatedSize):
            return CVGridSection(estimatedSize, environment: environment)
        }
    }
    
    return layout
}
#endif
