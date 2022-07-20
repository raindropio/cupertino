import UIKit

public func CollectionViewListLayout() -> UICollectionViewCompositionalLayout {
    .init { sectionIndex, layout in
        let section = NSCollectionLayoutSection.list(
            using: .init(appearance: .plain),
            layoutEnvironment: layout
        )
        
        section.boundarySupplementaryItems = [
            //header
            .init(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)),
                elementKind: "header",
                alignment: .top
            )
        ]
        
        return section
    }
}
