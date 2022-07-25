import SwiftUI

let CVHeaderKind = "header"

let CVHeaderItem = NSCollectionLayoutBoundarySupplementaryItem(
    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)),
    elementKind: CVHeaderKind,
    alignment: .top
)
