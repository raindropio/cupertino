import SwiftUI

#if os(iOS)
let minColumns = 2
#else
let minColumns = 1
#endif

func CVGridSection(_ estimatedSize: CGSize, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
    let columns = max(Int(round(environment.container.effectiveContentSize.width / estimatedSize.width)), minColumns)
    
    //gap
    #if os(iOS)
    let gap: CGFloat = 8
    let inset: CGFloat = 16
    #else
    let gap: CGFloat = 4
    let inset: CGFloat = 8
    #endif
    
    //group
    let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedSize.height)
        ),
        subitem: .init(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(estimatedSize.height)
            )
        ),
        count: columns
    )
    group.interItemSpacing = .fixed(gap)
    
    //section
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = gap
    section.contentInsets = .init(top: 0, leading: inset, bottom: 0, trailing: inset)
    section.supplementariesFollowContentInsets = false
    
    //header & footer
    section.boundarySupplementaryItems = [
        CVHeaderItem,
        CVFooterItem
    ]
    
    return section
}
