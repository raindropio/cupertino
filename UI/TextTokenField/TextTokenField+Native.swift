import SwiftUI

//MARK: - Init
extension TextTokenField {
    public class Native: UISearchTextField {
        var base: TextTokenField
        var onSubmitAction: () -> Void
        
        init(_ base: TextTokenField, environment: EnvironmentValues) {
            self.base = base
            self.onSubmitAction = environment.onSubmitAction
            super.init(frame: .zero)
            
            //behaviour
            clearButtonMode = .never
            clearsOnInsertion = false
            clearsOnBeginEditing = false
            allowsCopyingTokens = true
            delegate = self

            //appearance
            borderStyle = .none
            leftView = nil
            leftViewMode = .never
            tokenBackgroundColor = UIColor { (traits) -> UIColor in
                traits.userInterfaceStyle == .dark ? .systemFill : .systemGray2
            }
            
            //font
            font = .preferredFont(forTextStyle: .body)
            
            //keyboard
            autocorrectionType = .no
            autocapitalizationType = .none
            spellCheckingType = .no
            
            //suggestions view
            inputAccessoryView = KeyboardButtons(base.suggestions, onPress: onSuggestionPress)
            
            //events
            self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

//MARK: - from SwiftUI
extension TextTokenField.Native {
    func update(_ base: TextTokenField, environment: EnvironmentValues) {
        self.base = base
        self.onSubmitAction = environment.onSubmitAction

        isUserInteractionEnabled = environment.isEnabled
        
        if placeholder != base.title {
            placeholder = base.title
        }
        
        if tokens.map(\.stringValue) != base.value {
            tokens = base.value.map { .init($0) }
        }
        
        updateSuggestions()
    }
    
    private func updateSuggestions() {
        guard let keyboardButtons = inputAccessoryView as? KeyboardButtons
        else { return }
        
        var available = base.suggestions.filter { !base.value.contains($0) }
        let filter = text?.localizedLowercase.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !filter.isEmpty {
            available = available.filter { $0.localizedLowercase.contains(filter) }
        }
        
        keyboardButtons.update(available)
    }
    
    private func onSuggestionPress(_ suggestion: String) {
        text = suggestion+","
        textFieldDidChange(self)
    }
}

//MARK: - Text change events
extension TextTokenField.Native: UITextFieldDelegate {
    //text change
    @objc func textFieldDidChange(_ textField: UITextField) {
        //convert text to tokens if there separator
        if (textField.text ?? "").contains(",") {
            (textField.text ?? "")
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
                .forEach { str in
                    if !tokens.contains(where: { $0.stringValue == str }) {
                        tokens.append(.init(str))
                    }
                }
            textField.text = ""
        }
        
        //commit tokens to swiftui
        let value = tokens.map { $0.stringValue }
        if base.value != value {
            base.value = value
        }
        
        updateSuggestions()
    }
    
    //press return
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //force lost focus
        if textField.text == "" {
            onSubmitAction()
            textField.resignFirstResponder()
            return true
        }
        else {
            textFieldDidEndEditing(textField)
            return false
        }
    }
    
    //lost focus
    public func textFieldDidEndEditing(_ textField: UITextField) {
        //append separator to end if there any text, to force convert to tokens
        if !(textField.text ?? "").isEmpty {
            textField.text = (textField.text ?? "") + ","
            textFieldDidChange(textField)
        }
    }
}

//MARK: - Copy tokens
extension TextTokenField.Native: UISearchTextFieldDelegate {
    public func searchTextField(_ searchTextField: UISearchTextField, itemProviderForCopying token: UISearchToken) -> NSItemProvider {
        let index = searchTextField.tokens.firstIndex(of: token)
        let last = (searchTextField.tokens.endIndex - 1) == index
        return .init(object: token.stringValue + (last ? "" : ",") as NSString)
    }
}

//MARK: - Remove padding
extension TextTokenField.Native {
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: .zero)
    }
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: .zero)
    }
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: .zero)
    }
}

//MARK: - UISearchToken extension
fileprivate extension UISearchToken {
    var stringValue: String { representedObject as? String ?? "" }
    
    convenience init(_ stringValue: String) {
        self.init(icon: nil, text: stringValue)
        representedObject = stringValue
    }
}
