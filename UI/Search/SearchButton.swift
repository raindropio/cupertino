import SwiftUI

struct SearchButton {
    #if canImport(UIKit)
    @Binding var controller: UISearchController?
    #endif
}

extension SearchButton: View {
    var body: some View {
        Button {
            #if canImport(UIKit)
            Task { [weak controller] in
                controller?.searchBar.becomeFirstResponder()
            }
            #endif
        } label: {
            Image(systemName: "magnifyingglass")
        }
    }
}
