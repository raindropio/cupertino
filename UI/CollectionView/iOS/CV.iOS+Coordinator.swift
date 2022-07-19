#if os(iOS)
import SwiftUI
import UIKit

extension CV { class Coordinator: NSObject, UICollectionViewDelegate {
    var collectionView: UICollectionView! = nil
    
    private var parent: CV
    private var dataSource: DataSource! = nil
    
    init(_ parent: CV) {
        self.parent = parent
        super.init()
        
        //collection view
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout(parent.style))
        collectionView.delegate = self
        
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
                .background {
                    if cell.isSelected || cell.isHighlighted {
                        Color.red
                    }
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
            collectionView.setCollectionViewLayout(makeLayout(parent.style), animated: true)
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
                collectionView.deselectItem(at: $0, animated: true)
                return
            }
        }
        
        //select new
        let selected = collectionView.indexPathsForSelectedItems?.compactMap { id($0) } ?? []
        parent.selection.forEach {
            if !selected.contains($0), let at = indexPath($0) {
                collectionView.selectItem(at: at, animated: true, scrollPosition: [])
            }
        }
    }
    
    private func rerender(animated: Bool = false) {
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems(
            collectionView.indexPathsForVisibleItems.compactMap { item($0) }
        )
        dataSource.apply(snapshot, animatingDifferences: animated)
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
    
    //Cell Selection
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView.isEditing, let item = item(indexPath) {
            parent.selection.insert(item.id)
        }
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if collectionView.isEditing, let id = id(indexPath) {
            parent.selection.remove(id)
        }
        return false
    }
    
    //Cell Highlighting
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        rerender()
    }

    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        rerender()
    }
    
    //MARK: - Helpers
    private func indexPath(_ item: Item) -> IndexPath? {
        if let index = parent.data.firstIndex(of: item) {
            return IndexPath(row: index, section: 0)
        }
        return nil
    }
    
    private func indexPath(_ id: Item.ID) -> IndexPath? {
        if let index = parent.data.firstIndex(where: { $0.id == id }) {
            return IndexPath(row: index, section: 0)
        }
        return nil
    }
    
    private func item(_ id: Item.ID) -> Item? {
        parent.data.first { $0.id == id }
    }
    
    private func item(_ indexPath: IndexPath) -> Item? {
        let index = indexPath.row
        if parent.data.indices.contains(index) {
            return parent.data[index]
        }
        return nil
    }
    
    private func id(_ indexPath: IndexPath) -> Item.ID? {
        if let item = item(indexPath) {
            return item.id
        }
        return nil
    }
}}
#endif
