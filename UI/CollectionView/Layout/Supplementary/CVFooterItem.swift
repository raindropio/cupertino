import SwiftUI

func CVFooterItem() -> NSCollectionLayoutBoundarySupplementaryItem {
    .init(
        layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20)),
        elementKind: "footer",
        alignment: .bottom
    )
}
