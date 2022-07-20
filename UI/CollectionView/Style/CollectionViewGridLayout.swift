import UIKit

public func CollectionViewGridLayout(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
    let gap: CGFloat = 5
    let padding: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 16 : 11
    
    let item = NSCollectionLayoutItem(
        layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(64))
    )
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: gap, bottom: 0, trailing: gap)
    
    let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(64)),
        subitems: [item]
    )
    group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: 0, trailing: padding)

    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = gap * 2
    return section
}
