#if os(iOS)
import SwiftUI
import UIKit

extension CV { class Coordinator: NSObject, UICollectionViewDelegate {
    //aliases
    typealias DataSource = UICollectionViewDiffableDataSource<String, Item>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<String, Item>
    typealias DataSourceTransaction = NSDiffableDataSourceTransaction<String, Item>
    typealias ContentRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Item>
    
    var collectionView: UICollectionView! = nil
    
    private var parent: CV
    private var dataSource: DataSource! = nil
    private var reordering = false
    
    init(_ parent: CV) {
        self.parent = parent
        super.init()
        
        //collection view
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout(parent.style))
        collectionView.delegate = self
        setAppearance()
        
        //edit mode
        collectionView.allowsSelectionDuringEditing = true
        collectionView.allowsMultipleSelectionDuringEditing = true
        
        //keyboard nav
        collectionView.allowsFocus = true
        collectionView.remembersLastFocusedIndexPath = true
        collectionView.selectionFollowsFocus = true
        
        //content
        let contentRegistration = ContentRegistration { cell, _, item in
            cell.contentConfiguration = UIHostingConfiguration {
                self.parent.content(item)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            cell.backgroundConfiguration = self.parent.style == .grid ? .listGroupedCell() : .listPlainCell()
            cell.backgroundConfiguration?.cornerRadius = self.parent.style == .grid ? 5 : 0
        }
        
        //data source
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: contentRegistration,
                for: indexPath,
                item: item
            )
        }
        
        //reordering
        dataSource.reorderingHandlers.canReorderItem = canReorderItem
        dataSource.reorderingHandlers.didReorder = didReorder
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(dragReorder(_:))))
        
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
            collectionView.setCollectionViewLayout(makeLayout(parent.style), animated: true) { [weak self] _ in
                UIView.animate(withDuration: 0.2) {
                    self?.setAppearance()
                    self?.rerender()
                }
            }
        }
        
        //changed data
        if dataChanged {
            setData()
        }
        
        //changed selection
        if selectionChanged {
            setSelection()
            rerender()
        }
    }
    
    func makeLayout(_ style: CollectionViewStyle) -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            switch style {
            case .list: return CollectionViewListLayout(layoutEnvironment)
            case .grid: return CollectionViewGridLayout(layoutEnvironment)
            }
        }
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
    
    private func setAppearance() {
        collectionView.backgroundColor = parent.style == .grid ? .systemGroupedBackground : nil
    }
    
    private func rerender(_ single: Item? = nil, animated: Bool = false) {
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems(
            single != nil ?
                [single!] :
                collectionView.indexPathsForVisibleItems.compactMap { item($0) }
        )
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    //MARK: - Reordering
    func canReorderItem(_ item: Item) -> Bool {
        parent.reorderAction != nil
    }
    
    func didReorder(_ transaction: DataSourceTransaction) {
        guard let reorderAction = parent.reorderAction else { return }
        
        if let insertion = transaction.difference.insertions.first {
            switch insertion {
            case .insert(let to, let element, _):
                reorderAction(element, to)
            default: break
            }
        }
    }
    
    @objc private func dragReorder(_ sender: UILongPressGestureRecognizer) {
        guard sender.view === collectionView else { return }
        
        switch(sender.state) {
        case .began:
            guard let indexPath = collectionView.indexPathForItem(at: sender.location(in: collectionView)) else { break }
            reordering = true
            collectionView.beginInteractiveMovementForItem(at: indexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(sender.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
            rerender()
            reordering = false
        default:
            collectionView.cancelInteractiveMovement()
            reordering = false
        }
    }
    
    //MARK: - CollectionView Delegate Methods
    //Primary action
    public func collectionView(_ collectionView: UICollectionView, canPerformPrimaryActionForItemAt indexPath: IndexPath) -> Bool {
        !collectionView.isEditing && parent.contextAction != nil
    }
    
    public func collectionView(_ collectionView: UICollectionView, performPrimaryActionForItemAt indexPath: IndexPath) {
        if let contextAction = parent.contextAction,
            parent.data.indices.contains(indexPath.row) {
            contextAction(parent.data[indexPath.row])
        }
    }
    
    //Context menu
    public func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        .init(identifier: nil, previewProvider: nil) { actions in
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash.fill"), identifier: nil) { action in
                // whatever
            }
            return UIMenu(title: "Menu", image: nil, identifier: nil, children:[delete])
        }
    }
    
    //Cell Selection
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView.isEditing, !reordering, let item = item(indexPath) {
            parent.selection.insert(item.id)
        }
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if collectionView.isEditing, !reordering, let id = id(indexPath) {
            parent.selection.remove(id)
        }
        return false
    }
    
    //Cell Highlighting
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        rerender(item(indexPath))
    }

    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        rerender(item(indexPath))
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
