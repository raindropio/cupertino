#if os(macOS)
import SwiftUI
import AppKit

func CVLayout(_ style: CollectionViewStyle) -> NSCollectionViewLayout {
    var layout: NSCollectionViewCompositionalLayout!
    
    layout = NSCollectionViewCompositionalLayout{ sectionIndex, environment in
        switch style {
        case .list:
            return CVListSection(environment: environment)
            
        case .grid(let idealWidth):
            let section = CVGridSection(idealWidth, environment: environment)
            section.visibleItemsInvalidationHandler = { _, _, _ in
                //layout.collectionView?.enclosingScrollView?.backgroundColor = .windowBackgroundColor
            }
            return section
        }
    }
    
    return layout
}
#endif
