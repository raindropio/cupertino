import SwiftUI

public extension Backport where Wrapped: View {
    func fixSearchAppearance() -> some View {
        content
            #if os(iOS)
            .overlay(Proxy().opacity(0))
            #endif
    }
}

#if os(iOS)
fileprivate struct Proxy: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> VC { .init() }
    func updateUIViewController(_ controller: VC, context: Context) {}
}

extension Proxy {
    class VC: UIViewController {
        var wait = false
        
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            
            if let searchController = parent?.navigationItem.searchController,
               searchController.searchBarPlacement != .inline,
               !searchController.isActive {
                searchController.searchBar.isHidden = !wait
            }
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            if let searchController = parent?.navigationItem.searchController,
               searchController.searchBarPlacement != .inline,
               !searchController.isActive {
                searchController.searchBar.isHidden = false
            }
            
            wait = false
        }
        
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            
            wait = true
        }
    }
}
#endif
