#if os(iOS)
import SwiftUI
import UIKit

func CVLayout(_ style: CollectionViewStyle) -> UICollectionViewLayout {
    var layout: UICollectionViewCompositionalLayout!
    
    layout = UICollectionViewCompositionalLayout{ sectionIndex, environment in
        switch style {
        case .list:
            return CVListSection(environment: environment)
            
        case .grid(let idealWidth):
            let section = CVGridSection(idealWidth, environment: environment)
            section.visibleItemsInvalidationHandler = { _, _, _ in
                layout.collectionView?.backgroundColor = .systemGroupedBackground
            }
            return section
        }
    }
    
    return layout
}
#endif
