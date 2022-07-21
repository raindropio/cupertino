import Cocoa
import SwiftUI

class HostCollectionItem: NSCollectionViewItem {
    static var identifier = NSUserInterfaceItemIdentifier("item")
    
    override func loadView() {
        view = NSView()
    }
    
    func host<Content>(_ rootView: Content) where Content: View {
        view = NSHostingView(rootView: rootView)
        if #available(macOS 13.0, *) {
            (view as? NSHostingView<Content>)?.sizingOptions = .preferredContentSize
        }
    }
}
