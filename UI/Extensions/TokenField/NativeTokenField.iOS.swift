#if os(iOS)
import SwiftUI
import SwiftUIX

extension TokenField {
    struct NativeTokenField: UIViewRepresentable {
        @Binding public var value: [String]
        var prompt: String
        var suggestions: (_ text: String) -> [TokenFieldSuggestion]

        public func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        public func makeUIView(context: Context) -> UISearchBar {
            let searchBar = UISearchBar()
            searchBar.delegate = context.coordinator
            searchBar.searchTextField.delegate = context.coordinator

            //appearance
            searchBar.searchBarStyle = .minimal
            searchBar.setImage(.init(), for: .search, state: .normal)
            searchBar.searchTextField.borderStyle = .none
            searchBar.searchTextField.clearButtonMode = .never
            searchBar.searchTextField.font = context.environment.font?.toUIFont() ?? Font.body.toUIFont()
            searchBar.searchTextField.tokenBackgroundColor = Color.accentColor.toUIColor()
            searchBar.searchTextField.autocorrectionType = context.environment.disableAutocorrection.map({ $0 ? .no : .yes }) ?? .default
            searchBar.searchTextField.autocapitalizationType = .none
            searchBar.searchTextField.returnKeyType = .done

            //prompt
            searchBar.searchTextField.attributedPlaceholder = .init(
                string: prompt,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.tertiaryLabel]
            )
            
            return searchBar
        }

        public func updateUIView(_ searchBar: UISearchBar, context: Context) {
            searchBar.searchTextField.tokens = value.map {
                let token = UISearchToken(icon: nil, text: $0)
                token.representedObject = $0
                return token
            }
        }

        public class Coordinator: NSObject, UISearchBarDelegate, UISearchTextFieldDelegate {
            var parent: NativeTokenField

            init(_ parent: NativeTokenField) {
                self.parent = parent
            }
            
            //split text to tokens and save to swiftui value
            private func apply(_ searchBar: UISearchBar) {
                if let dirty = searchBar.text, !dirty.isEmpty {
                    dirty.split(separator: ",").forEach {
                        let text = String($0).trimmingCharacters(in: .whitespacesAndNewlines)
                        if !text.isEmpty {
                            let token = UISearchToken(icon: nil, text: text)
                            token.representedObject = text
                            searchBar.searchTextField.tokens.append(token)
                        }
                    }
                }
                
                searchBar.text = ""
                
                //update swiftui value
                parent.value = searchBar.searchTextField.tokens.compactMap {
                    $0.representedObject as? String
                }
            }
            
            //suggestions
            private func showSuggestions(_ searchBar: UISearchBar) {
                let suggestions = parent.suggestions(searchBar.text ?? "")
                
                if !suggestions.contains { if case .text(_) = $0 { return true } else { return false } } {
                    searchBar.searchTextField.searchSuggestions = []
                    return
                }
                
                searchBar.searchTextField.searchSuggestions = suggestions
                    .map {
                        switch $0 {
                        case .text(let text):
                            let suggestion = UISearchSuggestionItem(localizedSuggestion: text)
                            suggestion.representedObject = text
                            return suggestion
                            
                        case .section(let section):
                            return UISearchSuggestionItem(
                                localizedAttributedSuggestion: .init(
                                    string: section,
                                    attributes: [
                                        NSAttributedString.Key.foregroundColor: UIColor.tertiaryLabel
                                    ]
                                )
                            )
                        }
                    }
            }

            //text changed
            func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                if searchText.contains(",") {
                    apply(searchBar)
                }
                showSuggestions(searchBar)
            }
            
            //focus
            func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
                showSuggestions(searchBar)
            }
            
            //blur
            func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
                apply(searchBar)
            }
            
            //press enter
            func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                apply(searchBar)
            }
            
            //suggestion tap
            func searchTextField(
                _ searchTextField: UISearchTextField,
                didSelect suggestion: UISearchSuggestion
            ) {
                if let text = suggestion.representedObject as? String, !text.isEmpty {
                    searchTextField.text = text
                }
                searchTextField.endEditing(true)
                DispatchQueue.main.async {
                    searchTextField.becomeFirstResponder()
                }
            }
        }
    }
}
#endif
