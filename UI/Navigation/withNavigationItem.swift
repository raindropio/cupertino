import SwiftUI

public extension View {
    func withNavigationItem(
        _ navigationItem: Binding<UINavigationItem?>,
        onAppear: (() -> Void)? = nil,
        onDisappear: (() -> Void)? = nil
    ) -> some View {
        overlay {
            WithNavigationItem(
                navigationItem: navigationItem,
                onAppear: onAppear,
                onDisappear: onDisappear
            )
                .opacity(0)
        }
    }
}

fileprivate struct WithNavigationItem: UIViewControllerRepresentable {
    @Binding var navigationItem: UINavigationItem?
    var onAppear: (() -> Void)?
    var onDisappear: (() -> Void)?
    
    func makeUIViewController(context: Context) -> VC {
        VC {
            navigationItem = $0
        } onDidAppear: { _ in
            onAppear?()
        } onDisappear: { _ in
            onDisappear?()
        }
    }

    func updateUIViewController(_ controller: VC, context: Context) {}
    
    class VC: UIViewController {
        var onAvailable: (UINavigationItem) -> Void
        var onDidAppear: (UINavigationItem) -> Void
        var onWillDisappear: (UINavigationItem) -> Void
        
        init(
            onAvailable: @escaping (UINavigationItem) -> Void,
            onDidAppear: @escaping (UINavigationItem) -> Void,
            onDisappear: @escaping (UINavigationItem) -> Void
        ) {
            self.onAvailable = onAvailable
            self.onDidAppear = onDidAppear
            self.onWillDisappear = onDisappear
            super.init(nibName: nil, bundle: nil)
        }
        
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            if let navigationItem = parent?.navigationItem {
                onAvailable(navigationItem)
            }
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
                        
            if let navigationItem = parent?.navigationItem {
                onDidAppear(navigationItem)
            }
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            if let navigationItem = parent?.navigationItem {
                onWillDisappear(navigationItem)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

