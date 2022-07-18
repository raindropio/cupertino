#if os(iOS)
import SwiftUI
import SwiftUIX

struct NativeTokenFieldLabeledContentStyle: LabeledContentStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
    }
}

struct NativeTokenField: UIViewRepresentable {
    @Binding public var value: [String]
    var prompt: String
    var suggestions: [String]
    
    func textToToken(_ text: String) -> UISearchToken {
        let token = UISearchToken(icon: nil, text: text)
        token.representedObject = text
        return token
    }

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
        searchBar.searchTextField.tokenBackgroundColor = context.environment.tintColor?.toUIColor()
        searchBar.searchTextField.autocorrectionType = context.environment.disableAutocorrection.map({ $0 ? .no : .yes }) ?? .default
        searchBar.searchTextField.autocapitalizationType = .none
        searchBar.searchTextField.returnKeyType = .default
        
        //right button
        searchBar.showsCancelButton = true
        let rightButton = searchBar.value(forKey: "cancelButton") as! UIButton
        rightButton.setTitle("  ", for: .normal)
        rightButton.setImage(.init(systemName: "chevron.down.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        searchBar.showsCancelButton = !suggestions.isEmpty

        //prompt
        searchBar.searchTextField.attributedPlaceholder = .init(
            string: prompt,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.tertiaryLabel]
        )
        
        return searchBar
    }

    public func updateUIView(_ searchBar: UISearchBar, context: Context) {
        searchBar.searchTextField.tokens = value.map { textToToken($0) }
        searchBar.showsCancelButton = !suggestions.isEmpty
        context.coordinator.update(self)
    }

    public class Coordinator: NSObject, UISearchBarDelegate, UISearchTextFieldDelegate {
        var parent: NativeTokenField

        init(_ parent: NativeTokenField) {
            self.parent = parent
        }
        
        func update(_ parent: NativeTokenField) {
            self.parent = parent
        }
        
        private func sendValue(_ searchBar: UISearchBar) {
            //update swiftui value
            parent.value = searchBar.searchTextField.tokens
                .compactMap {
                    $0.representedObject as? String
                }
        }
        
        //split text to tokens and save to swiftui value
        private func apply(_ searchBar: UISearchBar) {
            if let dirty = searchBar.text, !dirty.isEmpty {
                dirty.split(separator: ",").forEach {
                    let text = String($0).trimmingCharacters(in: .whitespacesAndNewlines)
                    if !text.isEmpty {
                        let isNew = !searchBar.searchTextField.tokens.contains {$0.representedObject as? String == text}
                        if isNew {
                            searchBar.searchTextField.tokens.append(parent.textToToken(text))
                        }
                    }
                }
            }
            
            searchBar.text = ""
            
            sendValue(searchBar)
        }
        
        //suggestions
        private func showSuggestions(_ searchBar: UISearchBar) {
            sendValue(searchBar)
            
            searchBar.searchTextField.searchSuggestions = TokenFieldUtils
                .filter(parent.suggestions, value: parent.value, by: searchBar.text ?? "")
                .map {
                    let suggestion = UISearchSuggestionItem(localizedSuggestion: $0)
                    suggestion.representedObject = $0
                    return suggestion
                }
        }
        
        //right button click
        public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            if let count = searchBar.searchTextField.searchSuggestions?.count, count > 0 {
                searchBar.searchTextField.searchSuggestions = []
            } else {
                showSuggestions(searchBar)
            }
        }

        //text changed
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.contains(",") {
                apply(searchBar)
                searchBar.searchTextField.searchSuggestions = []
            }
            else if !searchText.isEmpty {
                showSuggestions(searchBar)
            } else {
                searchBar.searchTextField.searchSuggestions = []
            }
        }
                    
        //initial focus
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            
        }
        
        //blur
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            apply(searchBar)
        }
        
        //press enter
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            if let text = searchBar.text, text.isEmpty {
                searchBar.endEditing(true)
            }
            apply(searchBar)
        }
        
        //suggestion tap
        func searchTextField(
            _ searchTextField: UISearchTextField,
            didSelect suggestion: UISearchSuggestion
        ) {
            if let text = suggestion.representedObject as? String, !text.isEmpty {
                searchTextField.text = text
                searchTextField.insertText(",")
            }
        }
    }
}
#endif
