import SwiftUI

extension View {
    func withTabBarController(
        _ tabBarController: Binding<UITabBarController?>
    ) -> some View {
        overlay {
            WithTabBarController(
                tabBarController: tabBarController
            )
                .opacity(0)
        }
    }
}

fileprivate struct WithTabBarController: UIViewControllerRepresentable {
    @Binding var tabBarController: UITabBarController?

    func makeUIViewController(context: Context) -> VC {
        VC {
            tabBarController = $0
        }
    }

    func updateUIViewController(_ controller: VC, context: Context) {}
    
    class VC: UIViewController {
        var onAvailable: (UITabBarController?) -> Void
        
        init(
            onAvailable: @escaping (UITabBarController?) -> Void
        ) {
            self.onAvailable = onAvailable
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            if let tabBarController = parent?.tabBarController {
                onAvailable(tabBarController)
            }
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            if let tabBarController = parent?.tabBarController {
                onAvailable(tabBarController)
            }
        }
    }
}
