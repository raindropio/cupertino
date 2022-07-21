import SwiftUI

let CVFooterKind = "footer"

func CVFooterItem() -> NSCollectionLayoutBoundarySupplementaryItem {
    .init(
        layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20)),
        elementKind: CVFooterKind,
        alignment: .bottom
    )
}
