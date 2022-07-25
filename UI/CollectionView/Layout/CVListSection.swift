import SwiftUI

func CVListSection(_ estimatedHeight: CGFloat = 20, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
    #if os(iOS)
    var config = UICollectionLayoutListConfiguration(
        appearance: .plain
    )
    config.footerMode = .supplementary
    config.separatorConfiguration.topSeparatorVisibility = .hidden
    
    let section = NSCollectionLayoutSection.list(
        using: config,
        layoutEnvironment: environment
    )
    #else
    let section = NSCollectionLayoutSection(
        group: .horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(estimatedHeight)
            ),
            subitem: .init(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(estimatedHeight)
                )
            ),
            count: 1
        )
    )
    #endif
    
    section.boundarySupplementaryItems = [
        CVHeaderItem,
        CVFooterItem
    ]
    
    return section
}
