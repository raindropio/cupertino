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
    var moreButton: (() -> Void)?
    
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
        searchBar.searchTextField.spellCheckingType = searchBar.searchTextField.autocorrectionType == .no ? .no : .default
        searchBar.searchTextField.autocapitalizationType = .none
        searchBar.searchTextField.returnKeyType = .default
        searchBar.searchTextField.tintColor = UIColor.secondaryLabel
        
        //right button
        searchBar.showsCancelButton = true
        let rightButton = searchBar.value(forKey: "cancelButton") as! UIButton
        rightButton.isEnabled = true
        rightButton.setTitle("  ", for: .normal)
        var rightButtonImageConfig = UIImage.SymbolConfiguration(scale: .large)
        if let tintColor = context.environment.tintColor?.toUIColor() {
            rightButtonImageConfig = rightButtonImageConfig.applying(UIImage.SymbolConfiguration(hierarchicalColor: tintColor))
        }
        rightButton.setImage(.init(systemName: "ellipsis.circle.fill", withConfiguration: rightButtonImageConfig), for: .normal)
        searchBar.showsCancelButton = moreButton != nil

        //prompt
        searchBar.searchTextField.attributedPlaceholder = .init(
            string: prompt,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.tertiaryLabel]
        )
        
        return searchBar
    }

    public func updateUIView(_ searchBar: UISearchBar, context: Context) {
        searchBar.searchTextField.tokens = value.map { textToToken($0) }
        searchBar.showsCancelButton = moreButton != nil
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
        
        //more button click
        public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            if let moreButton = parent.moreButton {
                moreButton()
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
            
            //more button always enabled
            DispatchQueue.main.async { [weak searchBar] in
                if let cancelButton = searchBar?.value(forKey: "cancelButton") as? UIButton {
                    cancelButton.isEnabled = true
                }
            }
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
        
        //copy tokens
        func searchTextField(
            _ searchTextField: UISearchTextField,
            itemProviderForCopying token: UISearchToken
        ) -> NSItemProvider {
            var string = token.representedObject as? String ?? ""
            if !string.isEmpty {
                string += ","
            }
            return NSItemProvider(object: string as NSString)
        }
    }
}
#endif
