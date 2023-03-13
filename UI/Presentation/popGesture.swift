import SwiftUI

#if canImport(UIKit)
public extension View {
    func popGesture(_ mode: PopGestureMode = .automatic) -> some View {
        overlay(PopGesture(mode: mode).opacity(0))
    }
}

public enum PopGestureMode {
    case automatic
    case always
    case never
}

fileprivate struct PopGesture: UIViewControllerRepresentable {
    var mode: PopGestureMode
    
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
            
            switch base.mode {
            case .automatic:
                restore()
                
            case .never, .always:
                replace()
            }
        }
        
        func replace() {
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
            switch base.mode {
            case .always: return true
            case .never: return false
            case .automatic: return true
            }
        }
    }
}
#endif
