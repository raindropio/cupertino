import SwiftUI

public extension View {
    @available(iOS 15.0, *)
    func searchScopes(_ activation: UISearchController.ScopeBarActivation) -> some View {
        overlay(
            Proxy(activation: activation)
                .opacity(0)
        )
    }
}

@available(iOS 15.0, *)
fileprivate struct Proxy: UIViewControllerRepresentable {
    var activation: UISearchController.ScopeBarActivation
    
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
            guard searchController.scopeBarActivation != base.activation else { return }
            searchController.scopeBarActivation = base.activation
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
