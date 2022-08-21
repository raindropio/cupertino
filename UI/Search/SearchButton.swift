import SwiftUI

struct SearchButton {
    @Binding var controller: UISearchController?
}

extension SearchButton: View {
    var body: some View {
        Button {
            Task { [weak controller] in
                controller?.searchBar.becomeFirstResponder()
            }
        } label: {
            Image(systemName: "magnifyingglass")
        }
    }
}
