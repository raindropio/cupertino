import SwiftUI

extension View {
    func withSearchController(
        _ searchController: Binding<UISearchController?>,
        onAppear: (() -> Void)? = nil,
        onDisappear: (() -> Void)? = nil
    ) -> some View {
        background {
            WithSearchController(
                searchController: searchController,
                onAppear: onAppear,
                onDisappear: onDisappear
            )
        }
    }
}

fileprivate struct WithSearchController: UIViewControllerRepresentable {
    @Binding var searchController: UISearchController?
    var onAppear: (() -> Void)?
    var onDisappear: (() -> Void)?
    
    func makeUIViewController(context: Context) -> VC {
        VC {
            searchController = $0
        } onDidAppear: { _ in
            onAppear?()
        } onDisappear: { _ in
            onDisappear?()
        }
    }

    func updateUIViewController(_ controller: VC, context: Context) {}
    
    class VC: UIViewController {
        var onWillAppear: (UISearchController) -> Void
        var onDidAppear: (UISearchController) -> Void
        var onWillDisappear: (UISearchController) -> Void
        
        init(
            onWillAppear: @escaping (UISearchController) -> Void,
            onDidAppear: @escaping (UISearchController) -> Void,
            onDisappear: @escaping (UISearchController) -> Void
        ) {
            self.onWillAppear = onWillAppear
            self.onDidAppear = onDidAppear
            self.onWillDisappear = onDisappear
            super.init(nibName: nil, bundle: nil)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            if let searchController = parent?.navigationItem.searchController {
                onWillAppear(searchController)
            }
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            if let searchController = parent?.navigationItem.searchController {
                onDidAppear(searchController)
            }
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            if let searchController = parent?.navigationItem.searchController {
                onWillDisappear(searchController)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
