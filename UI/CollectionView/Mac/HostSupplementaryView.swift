#if os(macOS)
import Cocoa
import SwiftUI

final class HostSupplementaryView: NSView, NSCollectionViewElement {
    static var identifier = NSUserInterfaceItemIdentifier("UI.HostSupplementaryView")
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    func host<Content>(_ rootView: Content) where Content: View {
        if let view = subviews.first as? NSHostingView<Content>{
            view.rootView = rootView
        } else {
            let view = NSHostingView(rootView: rootView)
            self.addSubview(view)
            
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: topAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
            view.layer?.masksToBounds = true
        }
    }
}
#endif
