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
    
    //MARK: - Main
    func cleanup() {
        parent = nil
        dataSource = nil
    }
    
    func start(_ cv: NativeCollectionView) {
        if self.collectionView != nil { return }
        
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
        dataSource = DataSource(collectionView:collectionView){ [weak self] (collectionView, indexPath, item) -> NSCollectionViewItem? in
            guard
                let view = collectionView.makeItem(withIdentifier: HostCollectionItem.identifier, for: indexPath) as? HostCollectionItem,
                let content = self?.parent.content(item) else {
                return nil
            }
            view.host(content, isCard: self?.parent.style != .list)
            return view
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let view = collectionView.makeSupplementaryView(ofKind: kind, withIdentifier: HostSupplementaryView.identifier, for: indexPath) as? HostSupplementaryView else {
                return nil
            }
            self?.hostSupplementary(kind, view: view)
            return view
        }
        
        setData()
    }
    
    func update(_ parent: CV, environment: EnvironmentValues) {
        let styleChanged = self.parent.style != parent.style
        let dataChanged = self.parent.data != parent.data
        let selectionChanged = self.parent.selection != parent.selection
        
        self.parent = parent
        
        //changed data
        if dataChanged {
            setData()
        }
        
        //changed style
        if styleChanged {
            collectionView.collectionViewLayout = CVLayout(parent.style)
            reloadData()
        }
        
        //selection changed
        if selectionChanged || collectionView.selectionIndexes.count != parent.selection.count {
            collectionView.selectionIndexPaths = Set(parent.selection.compactMap { indexPath($0) })
        }
        
        //update header/footer
        updateSupplementary()
    }
    
    private func setData() {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([""])
        snapshot.appendItems(parent.data)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func reloadData(_ items: [Item]? = nil, animated: Bool = false) {
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems(
            items != nil ?
            items! :
                collectionView.indexPathsForVisibleItems().compactMap { item($0) }
        )
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    //MARK: - Supplementary
    private func hostSupplementary(_ kind: String, view: HostSupplementaryView) {
        switch kind {
        case CVHeaderKind: view.host(self.parent.header())
        case CVFooterKind: view.host(self.parent.footer())
        default: break
        }
    }
    
    private func updateSupplementary() {
        let invalidate = NSCollectionViewLayoutInvalidationContext()

        [CVHeaderKind, CVFooterKind].forEach {
            if let at = collectionView.indexPathsForVisibleSupplementaryElements(ofKind: $0).first,
               let view = collectionView.supplementaryView(forElementKind: $0, at: at) as? HostSupplementaryView {
                hostSupplementary($0, view: view)
                invalidate.invalidateSupplementaryElements(ofKind: $0, at: [at])
            }
        }
        
        if invalidate.invalidatedSupplementaryIndexPaths != nil {
            collectionView.collectionViewLayout?.invalidateLayout(with: invalidate)
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
}}
#endif
