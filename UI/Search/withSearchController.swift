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
        var onAvailable: (UISearchController) -> Void
        var onDidAppear: (UISearchController) -> Void
        var onWillDisappear: (UISearchController) -> Void
        
        init(
            onAvailable: @escaping (UISearchController) -> Void,
            onDidAppear: @escaping (UISearchController) -> Void,
            onDisappear: @escaping (UISearchController) -> Void
        ) {
            self.onAvailable = onAvailable
            self.onDidAppear = onDidAppear
            self.onWillDisappear = onDisappear
            super.init(nibName: nil, bundle: nil)
        }
        
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            if let searchController = parent?.navigationItem.searchController {
                onAvailable(searchController)
                
                //fix search blink, ios glitch
                if parent?.navigationItem.hidesSearchBarWhenScrolling ?? false,
                   searchController.searchBarPlacement != .inline {
                    searchController.searchBar.isHidden = true
                }
            }
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
                        
            if let searchController = parent?.navigationItem.searchController {
                onDidAppear(searchController)
                searchController.searchBar.isHidden = false
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
