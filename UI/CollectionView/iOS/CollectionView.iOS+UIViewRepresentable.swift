#if os(iOS)
import SwiftUI
import UIKit

extension CollectionView: UIViewRepresentable {
    public func layout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            switch style {
            case .list: return CollectionViewListLayout(layoutEnvironment)
            case .grid: return CollectionViewGridLayout(layoutEnvironment)
            }
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
        
        //content
        context.coordinator.contentRegistration = ContentRegistration { cell, _, item in
            cell.contentConfiguration = UIHostingConfiguration {
                content(item)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
                .background(cell.isSelected || cell.isHighlighted ? .red : .clear)
        }
        
        //data source
        context.coordinator.dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: context.coordinator.contentRegistration,
                for: indexPath,
                item: item
            )
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
#endif
