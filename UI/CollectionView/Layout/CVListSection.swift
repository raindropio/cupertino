import SwiftUI

func CVListSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
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
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(20)
            ),
            subitems: [
                .init(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(20)
                    )
                )
            ]
        )
    )
    #endif
    
    section.boundarySupplementaryItems = [
        CVHeaderItem(),
        CVFooterItem()
    ]
    
    return section
}
