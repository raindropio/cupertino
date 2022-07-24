#if os(macOS)
import Foundation
import AppKit

final class NativeCollectionView: NSCollectionView {
    var nativeDelegate: NativeCollectionViewDelegate?
    
    private func handlePrimaryAction() {
        if let first = self.selectionIndexPaths.first {
            nativeDelegate?.nativeCollectionView(self, performPrimaryActionForItemAt: first)
        }
    }
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 36 {
            handlePrimaryAction()
            return
        }
        
        super.keyDown(with: event)
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        if event.clickCount == 2 {
            handlePrimaryAction()
        }
    }
}

protocol NativeCollectionViewDelegate {
    func nativeCollectionView(_ collectionView: NSCollectionView, performPrimaryActionForItemAt indexPath: IndexPath)
}
#endif
