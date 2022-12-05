import SwiftUI

public extension Backport where Wrapped: View {
    @ViewBuilder func searchSuggestions<S: View>(@ViewBuilder _ suggestions: @escaping () -> S) -> some View {
        if #available(iOS 16, *) {
            content.searchSuggestions(suggestions)
        } else {
            content
//                .modifier(SS(suggestions: suggestions))
        }
    }
}

//fileprivate struct SS<S: View>: ViewModifier {
//    @StateObject private var service = BackportSearchSuggestionsService()
//    @State private var searchFocused = false
//    
//    var suggestions: () -> S
//    
//    private var isEmpty: Bool {
//        let view = suggestions()
//        return "\(view)" == "nil"
//    }
//    
//    func body(content: Content) -> some View {
//        content
//            .overlay {
//                if searchFocused, !isEmpty {
//                    List(content: suggestions)
//                        .listStyle(.plain)
//                        .background(.background)
//                }
//            }
//            .searchFocused($searchFocused)
//            .withSearchController($service.controller)
//            .environmentObject(service)
//    }
//}
//
//class BackportSearchSuggestionsService: ObservableObject {
//    @Published var controller: UISearchController?
//    
//    public func complete(_ string: String) {
//        guard let controller else { return }
//        controller.searchBar.text = string
//        controller.searchBar.delegate?.searchBar?(controller.searchBar, textDidChange: string)
//        controller.searchBar.endEditing(false)
//    }
//    
//    public func complete<T: Identifiable>(_ token: T) {
//        guard let controller else { return }
//        
//        let exists = controller.searchBar.searchTextField.tokens.contains {
//            ($0.representedObject as? T)?.id == token.id
//        }
//        guard !exists else { return }
//
//        let new = UISearchToken(icon: nil, text: "\(token.id)")
//        new.representedObject = token
//        controller.searchBar.searchTextField.insertToken(new, at: controller.searchBar.searchTextField.tokens.count)
//        
//        complete(" ")
//        complete("")
//    }
//}
