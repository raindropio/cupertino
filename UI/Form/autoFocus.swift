#if canImport(UIKit)
import SwiftUI

public extension View {
    func autoFocus(_ condition: Bool = true) -> some View {
        AutoFocus(content: self, condition: condition)
    }
}

struct AutoFocus<C: View>: UIViewControllerRepresentable {
    var content: C
    var condition: Bool
    
    func makeUIViewController(context: Context) -> Holder {
        let holder = Holder(rootView: content)
        holder.condition = condition
        return holder
    }
    
    func updateUIViewController(_ holder: Holder, context: Context) {
        holder.rootView = content
        holder.condition = condition
    }
    
    class Holder: UIHostingController<C> {
        var focused = false
        var condition = false
        
        override init(rootView: C) {
            super.init(rootView: rootView)
            view.backgroundColor = .clear
            view.isOpaque = false
        }
        
        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            
            if condition, !focused, let child = view.subviews.first?.subviews.first {
                focused = true
                DispatchQueue.main.async {
                    UIView.performWithoutAnimation {
                        child.becomeFirstResponder()
                    }
                }
            }
        }
        
        @MainActor required dynamic init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
#endif
