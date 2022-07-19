import UIKit

public func CollectionViewListLayout(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
    NSCollectionLayoutSection.list(
        using: .init(appearance: .plain),
        layoutEnvironment: layoutEnvironment
    )
}
