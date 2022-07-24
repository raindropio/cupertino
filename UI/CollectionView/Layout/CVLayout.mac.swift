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
            return CVGridSection(idealWidth, environment: environment)
        }
    }
    
    return layout
}
#endif
