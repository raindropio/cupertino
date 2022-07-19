#if os(iOS)
import SwiftUI
import UIKit

extension CollectionView {
    public class Coordinator: NSObject, UICollectionViewDelegate {
        //storage
        private var parent: CollectionView
        public var dataSource: DataSource! = nil
        public var contentRegistration: ContentRegistration! = nil
        
        //cached value
        private var _data: [Item] = []
        private var _selection = Set<Item.ID>()
        
        public init(_ parent: CollectionView) {
            self.parent = parent
        }
        
        //MARK: - Update
        public func update(_ parent: CollectionView, collectionView: UICollectionView) {
            self.parent = parent
            reload()
            renderSelection(collectionView: collectionView)
        }
        
        //MARK: - Data Source Reload
        private func snapshot() -> DataSourceSnapshot {
            var snapshot = DataSourceSnapshot()
            snapshot.appendSections([""])
            snapshot.appendItems(parent.data)
            return snapshot
        }
        
        private func reload() {
            guard _data.hashValue != parent.data.hashValue else { return }
            dataSource.apply(snapshot())
            _data = parent.data
        }
        
        private func reloadPartially(_ items: [Item], animated: Bool = false) {
            var snapshot = snapshot()
            snapshot.reconfigureItems(items)
            dataSource.apply(snapshot, animatingDifferences: animated)
        }
        
        private func renderSelection(collectionView: UICollectionView) {
            guard _selection.hashValue != parent.selection.hashValue else { return }
                        
            //deselect old
            collectionView.indexPathsForSelectedItems?.forEach {
                if let item = item($0), !parent.selection.contains(item.id) {
                    collectionView.deselectItem(at: $0, animated: true)
                }
            }
            
            //select new
            let selected = collectionView.indexPathsForSelectedItems?.compactMap { id($0) } ?? []
            parent.selection.forEach {
                if !selected.contains($0), let at = indexPath($0) {
                    collectionView.selectItem(at: at, animated: true, scrollPosition: [])
                }
            }
            
            reloadPartially(
                _selection
                    .symmetricDifference(parent.selection)
                    .compactMap { item($0) }
            )
            _selection = parent.selection
        }
        
        //MARK: - CollectionView Delegate Methods
        //Primary action
        public func collectionView(_ collectionView: UICollectionView, canPerformPrimaryActionForItemAt indexPath: IndexPath) -> Bool {
            return !collectionView.isEditing && parent.contextAction != nil
        }
        
        public func collectionView(_ collectionView: UICollectionView, performPrimaryActionForItemAt indexPath: IndexPath) {
            if let contextAction = parent.contextAction,
                parent.data.indices.contains(indexPath.row) {
                contextAction(parent.data[indexPath.row])
            }
        }
        
        //Cell Selection
        public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
            if collectionView.isEditing, let id = id(indexPath) {
                parent.selection.insert(id)
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
            if let item = item(indexPath) {
                reloadPartially([item])
            }
        }

        public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
            if let item = item(indexPath) {
                reloadPartially([item])
            }
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
    }
}
#endif
