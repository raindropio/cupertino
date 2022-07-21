import SwiftUI

let CVHeaderKind = "header"

func CVHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
    .init(
        layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)),
        elementKind: CVHeaderKind,
        alignment: .top
    )
}
