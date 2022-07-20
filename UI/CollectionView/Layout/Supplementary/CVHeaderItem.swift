import SwiftUI

func CVHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
    .init(
        layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)),
        elementKind: "header",
        alignment: .top
    )
}
