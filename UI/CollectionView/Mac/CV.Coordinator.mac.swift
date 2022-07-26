#if os(macOS)
import SwiftUI
import AppKit

extension CV { class Coordinator: NSObject, NSCollectionViewDelegate, NativeCollectionViewDelegate {
    private typealias DataSource = NSCollectionViewDiffableDataSource<String, Item>
    private typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<String, Item>
    
    private weak var collectionView: NativeCollectionView! = nil
    
    private var parent: CV! = nil
    private var dataSource: DataSource! = nil
    private var dragItems = Set<Item>()
    
    init(_ parent: CV) {
        self.parent = parent
        super.init()
    }
    
    //MARK: - Main
    func cleanup() {
        parent = nil
        dataSource = nil
        dragItems = []
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
        
        //reordering
        collectionView.setDraggingSourceOperationMask(.move, forLocal: true)
        collectionView.registerForDraggedTypes([.string])
        
        //data source
        dataSource = DataSource(collectionView:collectionView){ [weak self] (collectionView, indexPath, item) -> NSCollectionViewItem? in
            guard
                let view = collectionView.makeItem(withIdentifier: HostCollectionItem.identifier, for: indexPath) as? HostCollectionItem,
                let content = self?.parent.content(item) else {
                return nil
            }
            let isCard = {
                if case .list = self?.parent.style {
                    return false
                }
                return true
            }()
            view.host(
                content.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading),
                isCard: isCard
            )
            return view
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let view = collectionView.makeSupplementaryView(ofKind: kind, withIdentifier: HostSupplementaryView.identifier, for: indexPath) as? HostSupplementaryView else {
                return nil
            }
            self?.hostHelmet(kind, view: view)
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
            updateSelection()
        }
        
        //update header/footer
        updateHelmet()
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
    
    private func updateSelection() {
        let actual = Set(parent.selection.compactMap(indexPath))
        if actual != collectionView.selectionIndexPaths {
            collectionView.selectionIndexPaths = actual
        }
    }
    
    //MARK: - Supplementary
    private func hostHelmet(_ kind: String, view: HostSupplementaryView) {
        switch kind {
        case CVHeaderKind: view.host(self.parent.header().frame(maxWidth: .infinity, alignment: .leading))
        case CVFooterKind: view.host(self.parent.footer().frame(maxWidth: .infinity, alignment: .leading))
        default: break
        }
    }
    
    private func updateHelmet() {
        let invalidate = NSCollectionViewLayoutInvalidationContext()
        
        [CVHeaderKind, CVFooterKind].forEach {
            if let at = collectionView.indexPathsForVisibleSupplementaryElements(ofKind: $0).first,
               let view = collectionView.supplementaryView(forElementKind: $0, at: at) as? HostSupplementaryView {                
                hostHelmet($0, view: view)
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
    
    //Reordering
    func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexPaths: Set<IndexPath>, with event: NSEvent) -> Bool {
        parent.reorderAction != nil
    }
    
    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
        
        let retorno = NSPasteboardItem()
        retorno.setData(Data("test".utf8), forType: .string)
        return retorno
    }
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItemsAt indexPaths: Set<IndexPath>) {
        dragItems = Set(indexPaths.compactMap(item))
    }
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
        dragItems = .init()
    }
    
    func collectionView(_ collectionView: NSCollectionView, validateDrop draggingInfo: NSDraggingInfo, proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath>, dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionView.DropOperation>) -> NSDragOperation {
        if dragItems.isEmpty {
            return .copy
        }
        
        if proposedDropOperation.pointee == .before {
            proposedDropOperation.pointee = .on
        }
        
        if dragItems.count == 1,
           let origin = dragItems.first,
            let destination = item(proposedDropIndexPath.pointee) {
            if origin != destination {
                let from = indexPath(origin)!.item
                let to = indexPath(destination)!.item

                var snapshot = dataSource.snapshot()
                if from <= to {
                    snapshot.moveItem(origin, afterItem: destination)
                } else {
                    snapshot.moveItem(origin, beforeItem: destination)
                }
                
                dataSource.apply(snapshot, animatingDifferences: true)
            }
            return .move
        }
        
        return .generic
    }
    
    func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, indexPath: IndexPath, dropOperation: NSCollectionView.DropOperation) -> Bool {
        if dragItems.count == 1,
           let reorderAction = parent.reorderAction,
           let origin = dragItems.first {
            reorderAction(origin, indexPath.item)
            return true
        }
        return false
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
    
    private func item(_ indexPath: NSIndexPath) -> Item? {
        item(IndexPath(item: indexPath.item, section: indexPath.section))
    }
    
    private func id(_ indexPath: IndexPath) -> Item.ID? {
        if let item = item(indexPath) {
            return item.id
        }
        return nil
    }
}}
#endif
