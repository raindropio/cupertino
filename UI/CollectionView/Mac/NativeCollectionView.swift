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
    
    override func becomeFirstResponder() -> Bool {
        let become = super.becomeFirstResponder()
        if become {
            //select first element
            if selectionIndexPaths.isEmpty {
                if numberOfItems(inSection: 0) != 0 {
                    selectionIndexPaths = [.init(item: 0, section: 0)]
                    delegate?.collectionView?(self, didSelectItemsAt: selectionIndexPaths)
                }
            }
            //update selection appearance
            else {
                selectionIndexPaths.forEach {
                    item(at: $0)?.isSelected = true
                }
            }
        }
        return become
    }
    
    override func resignFirstResponder() -> Bool {
        let resigned = super.resignFirstResponder()
        if resigned {
            //update selection appearance
            selectionIndexPaths.forEach {
                item(at: $0)?.isSelected = true
            }
        }
        return resigned
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
