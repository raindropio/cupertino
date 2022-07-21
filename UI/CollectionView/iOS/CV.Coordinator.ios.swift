#if os(iOS)
import SwiftUI
import UIKit

extension CV { class Coordinator: NSObject, UICollectionViewDelegate, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    private typealias DataSource = UICollectionViewDiffableDataSource<String, Item>
    private typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<String, Item>
    private typealias DataSourceTransaction = NSDiffableDataSourceTransaction<String, Item>
    private typealias SupplementaryRegistration = UICollectionView.SupplementaryRegistration<UIHostingCollectionReusableView>
    private typealias ContentRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Item>
    
    private weak var controller: UICollectionViewController! = nil
    private weak var collectionView: UICollectionView! = nil
    
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
    
    func start(_ controller: UICollectionViewController) {
        self.controller = controller
        
        //collection view
        collectionView = controller.collectionView
        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        
        //edit mode
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.allowsSelectionDuringEditing = true
        collectionView.allowsMultipleSelectionDuringEditing = true
        
        //keyboard nav
        collectionView.allowsFocus = true
        collectionView.remembersLastFocusedIndexPath = true
        
        //header
        let headerRegistration = SupplementaryRegistration(elementKind: CVHeaderKind) { header, _, _ in
            header.host(AnyView(self.parent.header()), self.controller)
        }
        
        //footer
        let footerRegistration = SupplementaryRegistration(elementKind: CVFooterKind) { footer, _, _ in
            footer.host(AnyView(self.parent.footer()), self.controller)
        }
        
        //content
        let contentRegistration = ContentRegistration { cell, _, item in
            //background
            switch self.parent.style {
            case .list:
                cell.backgroundConfiguration = .listPlainCell()
                cell.backgroundConfiguration?.cornerRadius = 0
            case .grid(_):
                cell.backgroundConfiguration = .listGroupedCell()
                cell.backgroundConfiguration?.cornerRadius = 5
            }
            
            //view
            cell.contentConfiguration = UIHostingConfiguration {
                self.parent.content(item)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        
        //data source
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: contentRegistration,
                for: indexPath,
                item: item
            )
        }
        dataSource.supplementaryViewProvider = { _, kind, index in
            self.collectionView.dequeueConfiguredReusableSupplementary(
                using: kind == CVHeaderKind ? headerRegistration : footerRegistration,
                for: index
            )
        }
        
        //reordering
        dataSource.reorderingHandlers.canReorderItem = canReorderItem
        dataSource.reorderingHandlers.didReorder = didReorder
        
        //set data
        setData()
    }
    
    func update(_ parent: CV, environment: EnvironmentValues) {
        let styleChanged = self.parent.style != parent.style
        let dataChanged = self.parent.data != parent.data
        let selectionChanged = self.parent.selection != parent.selection || (collectionView.indexPathsForSelectedItems?.count ?? 0) != parent.selection.count
        
        self.parent = parent
        
        //edit mode
        collectionView.isEditing = environment.editMode?.wrappedValue.isEditing ?? false
        
        //changed style
        if styleChanged {
            collectionView.setCollectionViewLayout(CVLayout(parent.style), animated: false)
            render()
        }
        
        //changed data
        if dataChanged {
            setData()
        }
        
        //changed selection
        if selectionChanged {
            setSelection()
            render()
        }
        
        //update header/footer
        renderSupplementary()
    }
    
    private func setData() {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([""])
        snapshot.appendItems(parent.data)
        dataSource.apply(snapshot)
    }
    
    private func setSelection() {
        //deselect old
        collectionView.indexPathsForSelectedItems?.forEach {
            guard let item = item($0), parent.selection.contains(item.id) else {
                collectionView.deselectItem(at: $0, animated: false)
                return
            }
        }
        
        //select new
        let selected = collectionView.indexPathsForSelectedItems?.compactMap { id($0) } ?? []
        parent.selection.forEach {
            if !selected.contains($0), let at = indexPath($0) {
                collectionView.selectItem(at: at, animated: false, scrollPosition: [])
            }
        }
    }
    
    private func render(_ single: Item? = nil, animated: Bool = false) {
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems(
            single != nil ?
                [single!] :
                collectionView.indexPathsForVisibleItems.compactMap { item($0) }
        )
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    private func renderSupplementary() {
        var refresh = false
        if let header = visibleSupplementaryView(CVHeaderKind) {
            header.host(AnyView(parent.header()), controller)
            refresh = true
        }
        if let footer = visibleSupplementaryView(CVFooterKind) {
            footer.host(AnyView(parent.footer()), controller)
            refresh = true
        }
        if refresh {
            render()
        }
    }
    
    //MARK: - Reordering
    //Enable reordering
    private func canReorderItem(_ item: Item) -> Bool {
        parent.reorderAction != nil
    }
    
    //End reordering
    private func didReorder(_ transaction: DataSourceTransaction) {
        guard let reorderAction = parent.reorderAction else { return }
        guard let insertion = transaction.difference.insertions.first else { return }
        
        switch insertion {
        case .insert(let to, let element, _):
            reorderAction(element, to)
        default: break;
        }
    }
    
    //Drag start (required)
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning _: UIDragSession, at _: IndexPath) -> [UIDragItem] {
        []
    }
    
    //Dropped something (required)
    func collectionView(_ collectionView: UICollectionView, performDropWith _: UICollectionViewDropCoordinator) {
    }
    
    //MARK: - CollectionView Delegate Methods
    //Primary action
    func collectionView(_ collectionView: UICollectionView, canPerformPrimaryActionForItemAt indexPath: IndexPath) -> Bool {
        if !collectionView.isEditing, parent.contextAction != nil {
            return true
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, performPrimaryActionForItemAt indexPath: IndexPath) {
        if let contextAction = parent.contextAction,
           let item = item(indexPath) {
            //simulate select
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            render(item)
            
            contextAction(item)
            
            //reset selection
            Task {
                try? await Task.sleep(until: .now + .seconds(0.3), clock: .continuous)
                parent.selection = .init()
            }
        }
    }
    
    //Context menu
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        .init(identifier: nil, previewProvider: nil) { actions in
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash.fill"), identifier: nil) { action in
                // whatever
            }
            return UIMenu(title: "Menu", image: nil, identifier: nil, children:[delete])
        }
    }
    
    //Cell Selection
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let item = item(indexPath) {
            parent.selection.insert(item.id)
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if let id = id(indexPath) {
            parent.selection.remove(id)
        }
        return false
    }
    
    //Cell Highlighting
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        render(item(indexPath))
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        render(item(indexPath))
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
    
    private func visibleSupplementaryView(_ ofKind: String) -> UIHostingCollectionReusableView? {
        if let at = collectionView.indexPathsForVisibleSupplementaryElements(ofKind: ofKind).first {
            return collectionView.supplementaryView(forElementKind: ofKind, at: at) as? UIHostingCollectionReusableView
        }
        return nil
    }
}}
#endif
