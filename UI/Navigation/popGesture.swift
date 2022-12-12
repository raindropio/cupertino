import SwiftUI

public extension View {
    func popGesture(_ isEnabled: Bool = true) -> some View {
        overlay(PopGesture(isEnabled: isEnabled).opacity(0))
    }
}

fileprivate struct PopGesture: UIViewControllerRepresentable {
    var isEnabled: Bool
    
    func makeUIViewController(context: Context) -> VC {
        .init(self)
    }

    func updateUIViewController(_ controller: VC, context: Context) {
        controller.update(self)
    }
}

extension PopGesture {
    class VC: UIViewController, UIGestureRecognizerDelegate {
        var base: PopGesture
        weak var defaultGestureRecognizerDelegate: UIGestureRecognizerDelegate?
        
        init(_ base: PopGesture) {
            self.base = base
            super.init(nibName: nil, bundle: nil)
        }
        
        func update(_ base: PopGesture) {
            self.base = base
            
            if base.isEnabled {
                restore()
            } else {
                disable()
            }
        }
        
        func disable() {
            if defaultGestureRecognizerDelegate == nil {
                defaultGestureRecognizerDelegate = parent?.navigationController?.interactivePopGestureRecognizer?.delegate
            }
            parent?.navigationController?.interactivePopGestureRecognizer?.delegate = self
        }
        
        func restore() {
            if let defaultGestureRecognizerDelegate {
                parent?.navigationController?.interactivePopGestureRecognizer?.delegate = defaultGestureRecognizerDelegate
            }
        }
        
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            update(base)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            update(base)
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            restore()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            return false
        }
    }
}
