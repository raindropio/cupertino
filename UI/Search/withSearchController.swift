import SwiftUI
import Combine

extension View {
    func withSearchController(
        _ searchController: Binding<UISearchController?>,
        onAppear: (() -> Void)? = nil,
        onDisappear: (() -> Void)? = nil,
        onVisibilityChange: ((Bool) -> Void)? = nil
    ) -> some View {
        overlay {
            WithSearchController(
                searchController: searchController,
                onAppear: onAppear,
                onDisappear: onDisappear,
                onVisibilityChange: onVisibilityChange
            )
                .opacity(0)
        }
    }
}

fileprivate struct WithSearchController: UIViewControllerRepresentable {
    @Binding var searchController: UISearchController?
    var onAppear: (() -> Void)?
    var onDisappear: (() -> Void)?
    var onVisibilityChange: ((Bool) -> Void)?
    
    func makeUIViewController(context: Context) -> VC {
        VC {
            searchController = $0
        } onDidAppear: { _ in
            onAppear?()
        } onDisappear: { _ in
            onDisappear?()
        } onVisibilityChange: { _, visible in
            onVisibilityChange?(visible)
        }
    }

    func updateUIViewController(_ controller: VC, context: Context) {}
    
    class VC: UIViewController {
        private var cancellables = Set<AnyCancellable>()
        
        var onAvailable: (UISearchController) -> Void
        var onDidAppear: (UISearchController) -> Void
        var onWillDisappear: (UISearchController) -> Void
        var onVisibilityChange: (UISearchController, Bool) -> Void
        
        init(
            onAvailable: @escaping (UISearchController) -> Void,
            onDidAppear: @escaping (UISearchController) -> Void,
            onDisappear: @escaping (UISearchController) -> Void,
            onVisibilityChange: @escaping (UISearchController, Bool) -> Void
        ) {
            self.onAvailable = onAvailable
            self.onDidAppear = onDidAppear
            self.onWillDisappear = onDisappear
            self.onVisibilityChange = onVisibilityChange
            super.init(nibName: nil, bundle: nil)
        }
        
        private func observe(_ controller: UISearchController) {
            cancellables = .init()
            
            //track visibility
            controller.searchBar.publisher(for: \.frame)
                .removeDuplicates { ($0.height == 0) == ($1.height == 0) }
                .sink { [weak controller] in
                    if let controller {
                        let isVisible = controller.searchBarPlacement == .inline || !controller.searchBar.isHidden && ($0.height != 0)
                        self.onVisibilityChange(controller, isVisible)
                    }
                }
                .store(in: &cancellables)
        }
        
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            
            if let navigationItem = parent?.navigationItem,
                let searchController = navigationItem.searchController {
                if navigationItem.hidesSearchBarWhenScrolling {
                    searchController.searchBar.isHidden = true
                }
                
                
                onAvailable(searchController)
                observe(searchController)
            }
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
                        
            if let searchController = parent?.navigationItem.searchController {
                searchController.searchBar.isHidden = false
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
