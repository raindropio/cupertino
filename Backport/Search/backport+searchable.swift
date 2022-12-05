import SwiftUI
import Combine

public extension Backport where Wrapped: View {
    @ViewBuilder func searchable<C: RandomAccessCollection & RangeReplaceableCollection & Equatable, T: View>(
        text: Binding<String>,
        tokens: Binding<C>,
        placement: SearchFieldPlacement = .automatic,
        prompt: Text? = nil,
        token: @escaping (C.Element) -> T
    ) -> some View where C.Element : Identifiable {
        if #available(iOS 16, *) {
            content
                .searchable(text: text, tokens: tokens, placement: placement, prompt: prompt, token: token)
        } else {
            content
//                .searchable(text: text, placement: placement, prompt: prompt)
//                .modifier(SearchTokens(tokens: tokens))
        }
    }
}

//fileprivate struct SearchTokens<C: RandomAccessCollection & RangeReplaceableCollection & Equatable>: ViewModifier where C.Element: Identifiable {
//    @StateObject private var service = Service()
//    
//    @Binding var tokens: C
//    
//    @Sendable
//    private func send() async {
//        guard let controller = service.controller else { return }
//        
//        controller.searchBar.searchTextField.tokens = tokens.map {
//            let token = UISearchToken(icon: nil, text: "\($0.id)")
//            token.representedObject = $0
//            return token
//        }
//    }
//    
//    @Sendable
//    private func receive() async {
//        let new = service.controller?.searchBar.searchTextField.tokens.compactMap { $0.representedObject } as? C
//        if let new {
//            tokens = new
//        }
//    }
//    
//    func body(content: Content) -> some View {
//        content
//            .withSearchController($service.controller)
//            .environmentObject(service)
//            .task(id: tokens, send)
//            .task(id: service.controller?.searchBar.searchTextField.tokens, receive)
//    }
//}
//
//fileprivate class Service: NSObject, ObservableObject {
//    private var cancelables = Set<AnyCancellable>()
//
//    @Published var controller: UISearchController? {
//        didSet {
//            bind()
//        }
//    }
//    
//    func bind() {
//        guard let controller else { return }
//        
//        //TODO: Doesnt update on search end
//
//        controller.searchBar.publisher(for: \.isFirstResponder)
//            .sink { _ in self.objectWillChange.send() }
//            .store(in: &cancelables)
//        
//        controller.searchBar.searchTextField.addTarget(self, action: #selector(self.didChange(_:)), for: .allEvents)
//    }
//    
//    @objc func didChange(_ textField: UITextField) {
//        objectWillChange.send()
//    }
//}
