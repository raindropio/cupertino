import SwiftUI

func CVGridSection(_ idealWidth: CGFloat, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
    let columns = Int(max(round(environment.container.effectiveContentSize.width / idealWidth), 2))
    
    //gap
    #if os(iOS)
    let gap: CGFloat = 5
    let inset: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 16 : 11
    #else
    let gap: CGFloat = 4
    let inset: CGFloat = 8
    #endif
    
    //group
    let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(64)
        ),
        subitem: .init(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(64)
            )
        ),
        count: columns
    )
    group.interItemSpacing = .fixed(gap)
    
    //section
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = gap
    section.contentInsets = .init(top: 0, leading: inset, bottom: 0, trailing: inset)
    
    //header & footer
    section.boundarySupplementaryItems = [
        CVHeaderItem(),
        CVFooterItem()
    ]
    
    return section
}
