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
    
    func host<Content>(_ rootView: Content) where Content: View {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        let view = NSHostingView(rootView: rootView.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading))
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
        view.layer?.masksToBounds = true
    }
}
#endif
