import SwiftUI

func CVListSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
    let section = NSCollectionLayoutSection.list(
        using: .init(appearance: .plain),
        layoutEnvironment: environment
    )
    
    section.boundarySupplementaryItems = [
        CVHeaderItem(),
        CVFooterItem()
    ]
    
    return section
}
