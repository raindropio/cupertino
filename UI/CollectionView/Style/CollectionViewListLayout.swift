import UIKit

public func CollectionViewListLayout() -> UICollectionViewCompositionalLayout {
    .init { sectionIndex, layout in
        let section = NSCollectionLayoutSection.list(
            using: .init(appearance: .plain),
            layoutEnvironment: layout
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(20)
            ),
            elementKind: "header",
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}
