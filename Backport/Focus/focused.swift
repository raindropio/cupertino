import SwiftUI

public extension Backport where Wrapped: View {
    func focused(_ condition: FocusState<Bool>.Binding) -> some View {
        focused(condition, equals: true)
    }
    
    func focused<Value: Hashable>(_ binding: FocusState<Value>.Binding, equals value: Value) -> some View {
        content
            .focused(binding, equals: value)
            #if os(iOS)
            .overlay(Proxy(value: value).opacity(0))
            #endif
    }
}

#if os(iOS)
fileprivate struct Proxy<V: Hashable>: UIViewRepresentable {
    var value: V
    @Environment(\.backportDefaultFocus) private var defaultFocus
    func makeUIView(context: Context) -> Introspect { .init() }
    func updateUIView(_ view: Introspect, context: Context) {
        guard let df = defaultFocus as? V, df == value else { return }
        Task { view.focus() }
    }
}

fileprivate class Introspect: UIView {
    var done = false
    
    required init() {
        super.init(frame: .zero)
        isHidden = true
        isUserInteractionEnabled = false
    }
    
    func focus() {
        guard !done else { return }
        guard let parent = superview?.superview else { return }
        if let field = parent.findResponder() {
            field.becomeFirstResponder()
        }
        done = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    fileprivate func findResponder() -> UIView? {
        for view in subviews {
            if view.canBecomeFirstResponder {
                return view
            }
            if let sub = view.findResponder() {
                return sub
            }
        }
        return nil
    }
}
#endif
