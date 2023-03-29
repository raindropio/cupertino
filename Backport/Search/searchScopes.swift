import SwiftUI

public extension Backport where Wrapped: View {
    @ViewBuilder func searchScopes<V: Hashable, S: View>(
        _ scope: Binding<V>,
        activation: BackportSearchScopeActivation,
        @ViewBuilder _ scopes: @escaping () -> S
    ) -> some View {
        if #available(iOS 16.4, macOS 13.3, *) {
            content.searchScopes(scope, activation: activation.convert(), scopes)
        } else {
            content
                #if canImport(UIKit)
                .overlay(Proxy(activation: activation).opacity(0))
                #endif
                .searchScopes(scope, scopes: scopes)
        }
    }
}

public enum BackportSearchScopeActivation {
    case automatic
    case onTextEntry
    case onSearchPresentation
    
    @available(iOS 16.4, macOS 13.3, *)
    func convert() -> SwiftUI.SearchScopeActivation {
        switch self {
        case .automatic: return .automatic
        case .onTextEntry: return .onTextEntry
        case .onSearchPresentation: return .onSearchPresentation
        }
    }
    
    #if canImport(UIKit)
    func uiKit() -> UISearchController.ScopeBarActivation {
        switch self {
        case .automatic: return .automatic
        case .onTextEntry: return .onTextEntry
        case .onSearchPresentation: return .onSearchActivation
        }
    }
    #endif
}

#if canImport(UIKit)
fileprivate struct Proxy: UIViewControllerRepresentable {
    var activation: BackportSearchScopeActivation
    
    func makeUIViewController(context: Context) -> VC {
        .init(self)
    }

    func updateUIViewController(_ controller: VC, context: Context) {
        controller.update(self)
    }
}

extension Proxy {
    class VC: UIViewController {
        var base: Proxy
        var animate = false
        
        init(_ base: Proxy) {
            self.base = base
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @MainActor
        func update(_ base: Proxy) {
            self.base = base
            guard let searchController = parent?.navigationItem.searchController else { return }
            guard searchController.scopeBarActivation != base.activation.uiKit() else { return }
            
            searchController.scopeBarActivation = base.activation.uiKit()
        }
        
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            update(base)
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            update(base)
            animate = true
        }
    }
}
#endif
