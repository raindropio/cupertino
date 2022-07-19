#if os(iOS)
import SwiftUI
import UIKit

//Props etc
public struct CollectionView<Item: Identifiable, Content: View>: UIViewRepresentable where Item: Hashable {
    //aliases
    public typealias DataSource = UICollectionViewDiffableDataSource<String, Item>
    public typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<String, Item>
    public typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Item>
    
    //props
    public var data: [Item]
    @Binding public var selection: Set<Item.ID>
    public var content: (Item) -> Content
    
    //optionals
    private var contextAction: ((_ item: Item) -> Void)?
    public func contextAction(_ action: ((_ item: Item) -> Void)?) -> Self {
        var copy = self; copy.contextAction = action; return copy
    }
    
    public init(_ data: [Item], selection: Binding<Set<Item.ID>>, content: @escaping (Item) -> Content) {
        self.data = data
        self._selection = selection
        self.content = content
    }
}

//UI Preparation
extension CollectionView {
    public func layout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            NSCollectionLayoutSection.list(
                using: .init(appearance: .plain),
                layoutEnvironment: layoutEnvironment
            )
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    public func makeUIView(context: Context) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.delegate = context.coordinator
        
        //edit mode
        collectionView.allowsSelectionDuringEditing = true
        collectionView.allowsMultipleSelectionDuringEditing = true
        collectionView.isEditing = context.environment.editMode?.wrappedValue.isEditing ?? false
        
        //keyboard nav
        collectionView.allowsFocus = true
        collectionView.remembersLastFocusedIndexPath = true
        collectionView.selectionFollowsFocus = true
        
        //cells
        context.coordinator.cellRegistration = CellRegistration { cell, indexPath, item in
            cell.contentConfiguration = UIHostingConfiguration {
                content(item)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
                .background(cell.isSelected || cell.isHighlighted ? .red : .clear)
        }
        
        //data source
        context.coordinator.dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueConfiguredReusableCell(using: context.coordinator.cellRegistration, for: indexPath, item: item)
            return cell
        }
        
        //reload
        context.coordinator.update(self, collectionView: collectionView)
        
        return collectionView
    }
    
    public func updateUIView(_ uiView: UICollectionView, context: Context) {
        //edit mode
        let isEditing = context.environment.editMode?.wrappedValue.isEditing ?? false
        if uiView.isEditing != isEditing {
            //reset selection when edit mode turned off
            if !isEditing {
                DispatchQueue.main.async {
                    selection = .init()
                }
            }
            uiView.isEditing = isEditing
        }
        
        context.coordinator.update(self, collectionView: uiView)
    }
}

//UI & Data
extension CollectionView {
    public class Coordinator: NSObject, UICollectionViewDelegate {
        //storage
        fileprivate var parent: CollectionView
        fileprivate var dataSource: DataSource! = nil
        fileprivate var cellRegistration: CellRegistration! = nil
        
        //cached value
        fileprivate var _data: [Item] = []
        fileprivate var _selection = Set<Item.ID>()
        
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
                    collectionView.deselectItem(at: $0, animated: false)
                }
            }
            
            //select new
            let selected = collectionView.indexPathsForSelectedItems?.compactMap { id($0) } ?? []
            parent.selection.forEach {
                if !selected.contains($0), let at = indexPath($0) {
                    collectionView.selectItem(at: at, animated: false, scrollPosition: .centeredVertically)
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
