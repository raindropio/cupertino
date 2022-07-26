import SwiftUI

let CVFooterKind = "footer"

let CVFooterItem = NSCollectionLayoutBoundarySupplementaryItem(
    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20)),
    elementKind: CVFooterKind,
    alignment: .bottomLeading
)
