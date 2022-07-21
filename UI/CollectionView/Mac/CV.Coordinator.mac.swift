#if os(macOS)
import SwiftUI
import AppKit

extension CV { class Coordinator: NSObject {
    private typealias DataSource = NSCollectionViewDiffableDataSource<Int, Item>
    private typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, Item>
    
    private weak var collectionView: NSCollectionView! = nil
    
    private var parent: CV! = nil
    private var dataSource: DataSource! = nil
    
    init(_ parent: CV) {
        self.parent = parent
        super.init()
    }
    
    func cleanup() {
        parent = nil
        dataSource = nil
    }
    
    private func createLayout() -> NSCollectionViewLayout {
        let section = NSCollectionLayoutSection(
            group: .horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(20)
                ),
                subitems: [
                    .init(
                        layoutSize: .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(20)
                        )
                    )
                ]
            )
        )

        let layout = NSCollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func start(_ cv: NSCollectionView) {
        self.collectionView = cv
        
        collectionView.isSelectable = true
        collectionView.allowsEmptySelection = true
        collectionView.allowsMultipleSelection = true
        
        //layout & cells
        collectionView.register(HostCollectionItem.self, forItemWithIdentifier: HostCollectionItem.identifier)
        collectionView.collectionViewLayout = createLayout()
        
        //data source
        dataSource = DataSource(collectionView:collectionView){ (collectionView, indexPath, item) -> NSCollectionViewItem? in
            if let view = collectionView.makeItem(withIdentifier: HostCollectionItem.identifier, for: indexPath) as? HostCollectionItem {
                view.host(self.parent.content(item))
                return view
            }
            return nil
        }
        
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(parent.data, toSection:0)
        dataSource.apply(snapshot, animatingDifferences:false)
    }
    
    func update(_ parent: CV, environment: EnvironmentValues) {
        
    }
}}
#endif
