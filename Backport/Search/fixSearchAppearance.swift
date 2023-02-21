import SwiftUI

public extension Backport where Wrapped: View {
    @ViewBuilder func fixSearchAppearance() -> some View {
        content
            .overlay(Proxy().opacity(0))
    }
}

fileprivate struct Proxy: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> VC { .init() }
    func updateUIViewController(_ controller: VC, context: Context) {}
}

extension Proxy {
    class VC: UIViewController {
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            
            if let searchController = parent?.navigationItem.searchController,
               searchController.searchBarPlacement != .inline {
                searchController.searchBar.isHidden = true
            }
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            if let searchController = parent?.navigationItem.searchController,
               searchController.searchBarPlacement != .inline {
                searchController.searchBar.isHidden = false
            }
        }
    }
}
