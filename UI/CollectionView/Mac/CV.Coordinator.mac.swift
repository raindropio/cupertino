#if os(macOS)
import SwiftUI
import AppKit

extension CV { class Coordinator: NSObject, NSCollectionViewDelegate, NativeCollectionViewDelegate {
    private typealias DataSource = NSCollectionViewDiffableDataSource<String, Item>
    private typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<String, Item>
    
    private weak var collectionView: NativeCollectionView! = nil
    
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
    
    func start(_ cv: NativeCollectionView) {
        self.collectionView = cv
        collectionView.delegate = self
        collectionView.nativeDelegate = self
                
        collectionView.isSelectable = true
        collectionView.allowsEmptySelection = true
        collectionView.allowsMultipleSelection = true
        
        //layout & cells
        collectionView.register(HostCollectionItem.self, forItemWithIdentifier: HostCollectionItem.identifier)
        collectionView.register(HostSupplementaryView.self, forSupplementaryViewOfKind: CVHeaderKind, withIdentifier: HostSupplementaryView.identifier)
        collectionView.register(HostSupplementaryView.self, forSupplementaryViewOfKind: CVFooterKind, withIdentifier: HostSupplementaryView.identifier)
        collectionView.collectionViewLayout = CVLayout(parent.style)
        
        //data source
        dataSource = DataSource(collectionView:collectionView){ (collectionView, indexPath, item) -> NSCollectionViewItem? in
            guard let view = collectionView.makeItem(withIdentifier: HostCollectionItem.identifier, for: indexPath) as? HostCollectionItem else {
                return nil
            }
            view.host(self.parent.content(item), isCard: self.parent.style != .list)
            return view
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let view = collectionView.makeSupplementaryView(ofKind: kind, withIdentifier: HostSupplementaryView.identifier, for: indexPath) as? HostSupplementaryView else {
                return nil
            }
            switch kind {
            case CVHeaderKind: view.host(self.parent.header())
            case CVFooterKind: view.host(self.parent.footer())
            default: return nil
            }
            return view
        }
        
        setData()
    }
    
    func update(_ parent: CV, environment: EnvironmentValues) {
        let styleChanged = self.parent.style != parent.style
        let dataChanged = self.parent.data != parent.data
        let selectionChanged = self.parent.selection != parent.selection
        
        self.parent = parent
        
        //changed style
        if styleChanged {
            collectionView.collectionViewLayout = CVLayout(parent.style)
        }
        
        //changed data
        if dataChanged {
            setData()
        }
        
        //update header/footer
        renderSupplementary()
        
        if styleChanged || selectionChanged {
            render()
        }
    }
    
    private func setData() {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([""])
        snapshot.appendItems(parent.data)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func render(_ single: Item? = nil, animated: Bool = false) {
        //reaply data
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems(
            single != nil ?
                [single!] :
                collectionView.indexPathsForVisibleItems().compactMap { item($0) }
        )
        dataSource.apply(snapshot, animatingDifferences: animated)
        
        //update selection
        let newSelection = Set(parent.selection.compactMap { indexPath($0) })
        if collectionView.selectionIndexPaths != newSelection {
            collectionView.selectionIndexPaths = newSelection
        }
    }
    
    private func renderSupplementary() {
        if visibleSupplementaryView(CVHeaderKind) != nil ||
            visibleSupplementaryView(CVFooterKind) != nil {
            render()
        }
    }
    
    //MARK: - Native CollectionView Delegate Methods
    func nativeCollectionView(_ collectionView: NSCollectionView, performPrimaryActionForItemAt indexPath: IndexPath) {
        if let contextAction = parent.contextAction,
           let item = item(indexPath) {
            contextAction(item)
        }
    }
    
    //MARK: - CollectionView Delegate Methods
    //Cell Selection
    private func didSelectChange() {
        parent.selection = Set(collectionView.selectionIndexPaths.compactMap { id($0) })
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        didSelectChange()
    }
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        didSelectChange()
    }
    
    //MARK: - Helpers
    private func indexPath(_ item: Item) -> IndexPath? {
        dataSource.indexPath(for: item)
    }
    
    private func indexPath(_ id: Item.ID) -> IndexPath? {
        if let item = item(id) {
            return indexPath(item)
        }
        return nil
    }
    
    private func item(_ id: Item.ID) -> Item? {
        parent.data.first { $0.id == id }
    }
    
    private func item(_ indexPath: IndexPath) -> Item? {
        dataSource.itemIdentifier(for: indexPath)
    }
    
    private func id(_ indexPath: IndexPath) -> Item.ID? {
        if let item = item(indexPath) {
            return item.id
        }
        return nil
    }
    
    private func visibleSupplementaryView(_ ofKind: String) -> HostSupplementaryView? {
        if let at = collectionView.indexPathsForVisibleSupplementaryElements(ofKind: ofKind).first {
            return collectionView.supplementaryView(forElementKind: ofKind, at: at) as? HostSupplementaryView
        }
        return nil
    }
}}
#endif
