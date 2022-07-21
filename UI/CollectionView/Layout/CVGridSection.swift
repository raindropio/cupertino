import SwiftUI

func CVGridSection(_ idealWidth: CGFloat, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
    let columns = max(round(environment.container.effectiveContentSize.width / idealWidth), 2)
    let gap: CGFloat = 5
    #if os(iOS)
    let padding: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 16 : 11
    #else
    let padding: CGFloat = 11
    #endif
    
    //item size
    let item = NSCollectionLayoutItem(
        layoutSize: .init(
            widthDimension: .fractionalWidth(1 / columns),
            heightDimension: .estimated(64)
        )
    )
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: gap, bottom: 0, trailing: gap)
    
    let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(64)),
        subitems: [item]
    )
    group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding)
    
    //section
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = gap * 2
    section.boundarySupplementaryItems = [
        CVHeaderItem(),
        CVFooterItem()
    ]
    
    return section
}
