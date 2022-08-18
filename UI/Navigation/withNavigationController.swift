import SwiftUI

extension View {
    func withNavigationController(
        _ navigationController: Binding<UINavigationController?>,
        onAppear: (() -> Void)? = nil,
        onDisappear: (() -> Void)? = nil
    ) -> some View {
        overlay {
            WithNavigationController(
                navigationController: navigationController,
                onAppear: onAppear,
                onDisappear: onDisappear
            )
                .opacity(0)
        }
    }
}

fileprivate struct WithNavigationController: UIViewControllerRepresentable {
    @Binding var navigationController: UINavigationController?
    var onAppear: (() -> Void)?
    var onDisappear: (() -> Void)?
    
    func makeUIViewController(context: Context) -> VC {
        VC {
            navigationController = $0
        } onDidAppear: { _ in
            onAppear?()
        } onDisappear: { _ in
            onDisappear?()
        }
    }

    func updateUIViewController(_ controller: VC, context: Context) {}
    
    class VC: UIViewController {
        var onAvailable: (UINavigationController) -> Void
        var onDidAppear: (UINavigationController) -> Void
        var onWillDisappear: (UINavigationController) -> Void
        
        init(
            onAvailable: @escaping (UINavigationController) -> Void,
            onDidAppear: @escaping (UINavigationController) -> Void,
            onDisappear: @escaping (UINavigationController) -> Void
        ) {
            self.onAvailable = onAvailable
            self.onDidAppear = onDidAppear
            self.onWillDisappear = onDisappear
            super.init(nibName: nil, bundle: nil)
        }
        
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            if let navigationController = parent?.navigationController {
                onAvailable(navigationController)
            }
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
                        
            if let navigationController = parent?.navigationController {
                onDidAppear(navigationController)
            }
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            if let navigationController = parent?.navigationController {
                onWillDisappear(navigationController)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

