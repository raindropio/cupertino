import UIKit

public func CollectionViewGridLayout(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(
        layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(64))
    )
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
    
    let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(64)),
        subitems: [item]
    )
    group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)

    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 8
    return section
}
