import SwiftUI

public extension View {
    func searchFocus(_ type: SearchFocusType = .automatic) -> some View {
        modifier(SearchFocusModifier(type: type))
    }
}

public enum SearchFocusType {
    case automatic
    case initial
    case always
}

fileprivate struct SearchFocusModifier: ViewModifier {
    var type: SearchFocusType
    
    #if canImport(UIKit)
    @State private var searchController: UISearchController?

    func body(content: Content) -> some View {
        content
            .withSearchController($searchController) {
                switch type {
                case .always, .initial:
                    DispatchQueue.main.async { [weak searchController] in
                        searchController?.searchBar.becomeFirstResponder()
                    }
                    
                default:
                    break
                }
            } onDisappear: {}
            .onSubmit(of: .search) {
                if case .always = type {
                    searchController?.searchBar.becomeFirstResponder()
                }
            }
    }
    #else
    func body(content: Content) -> some View {
        content
    }
    #endif
}
