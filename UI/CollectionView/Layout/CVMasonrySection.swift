#if os(iOS)
import SwiftUI
import UIKit

//https://techblog.yahoo.co.jp/entry/2022071930317404/?cpt_n=BlogFeed&cpt_m=lnk&cpt_s=rss
//https://qiita.com/fromkk/items/475eb761fa3352829f52
//https://github.com/lucamegh/Niagara
//https://github.com/apptekstudios/ASCollectionView/blob/master/Sources/ASCollectionView/Layout/ASWaterfallLayout.swift
public func CollectionViewMasonryLayout() -> UICollectionViewCompositionalLayout {
    var numberOfItems: (Int) -> Int = { _ in 0 }
        
    let layout = UICollectionViewCompositionalLayout { (section, environment) -> NSCollectionLayoutSection? in
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(2000)) //.estimated(environment.container.effectiveContentSize.height)
        let group = NSCollectionLayoutGroup.custom(layoutSize: groupSize) { (environment) -> [NSCollectionLayoutGroupCustomItem] in
            var items: [NSCollectionLayoutGroupCustomItem] = []
            var layouts: [Int: CGFloat] = [:]
            let space: CGFloat = 1.0
            let numberOfColumn = CGFloat(2)
            let defaultSize = CGSize(width: 100, height: 100)

            (0 ..< numberOfItems(section)).forEach {
                let indexPath = IndexPath(item: $0, section: section)

                let size = defaultSize
                let aspect = CGFloat(size.height) / CGFloat(size.width)

                let width = (environment.container.effectiveContentSize.width - (numberOfColumn - 1) * space) / numberOfColumn
                let height = width * aspect

                let currentColumn = $0 % Int(numberOfColumn)
                let y = layouts[currentColumn] ?? 0.0 + space
                let x = width * CGFloat(currentColumn) + space * (CGFloat(currentColumn) - 1.0)

                let frame = CGRect(x: x, y: y + space, width: width, height: height)
                let item = NSCollectionLayoutGroupCustomItem(frame: frame)
                items.append(item)

                layouts[currentColumn] = frame.maxY
            }
            return items
        }
        return NSCollectionLayoutSection(group: group)
    }
    
    numberOfItems = { [weak layout] in
        layout?.collectionView?.numberOfItems(inSection: $0) ?? 0
    }
    
    return layout
}
#endif
