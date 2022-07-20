import UIKit

public func CollectionViewGridLayout(_ idealWidth: CGFloat = 250) -> UICollectionViewCompositionalLayout {
    var layout: UICollectionViewCompositionalLayout!
    
    layout = UICollectionViewCompositionalLayout{ sectionIndex, environment in
        let gap: CGFloat = 5
        let padding: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 16 : 11
        
        //item size
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(min(250 / environment.container.effectiveContentSize.width, 0.5)),
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
            //header
            .init(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)),
                elementKind: "header",
                alignment: .top
            )
        ]
        
        //full screen background
        section.visibleItemsInvalidationHandler = { _, _, _ in
            layout.collectionView?.backgroundColor = .systemGroupedBackground
        }
        
        return section
    }

    return layout
}
