#if os(macOS)
import Foundation
import SwiftUI
import AppKit

final class NSHostingCollectionViewItem : NSCollectionViewItem {
    static var identifier = NSUserInterfaceItemIdentifier("NSHostingCollectionViewItem")
    override var nibName:NSNib.Name? { nil }
    override var nibBundle:Bundle? { nil }
    
    override func loadView() {
        self.view = NSView()
        self.view.frame = .init(x: 0, y: 0, width: 100, height: 100)
        self.view.needsLayout = true
    }
}
#endif
