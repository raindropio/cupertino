#if canImport(AppKit)
import SwiftUI

//MARK: - Init
extension TextTokenField {
    public class Native: NSTokenField {
        var base: TextTokenField
        var onSubmitAction: () -> Void
        
        init(_ base: TextTokenField, environment: EnvironmentValues) {
            self.base = base
            self.onSubmitAction = environment.onSubmitAction
            super.init(frame: .zero)
            
            //behaviour
            delegate = self
                        
            //appearance
            tokenStyle = .squared
//            isBezeled = false
//            drawsBackground = false
            
            //font
            font = .preferredFont(forTextStyle: .body)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func preventSelectAll() {
            currentEditor()?.selectedRange = NSMakeRange(stringValue.count, 0)
        }
        
        @objc func showSuggestions() {
            currentEditor()?.complete(self)
        }
        
        public override func becomeFirstResponder() -> Bool {
            super.becomeFirstResponder()
            preventSelectAll()
            
            if NSApp.currentEvent == nil || NSApp.currentEvent!.type != .leftMouseDown {
                showSuggestions()
            } else {
                perform(#selector(showSuggestions), with: nil, afterDelay: 0.2)
            }
            
            return true
        }
        
        public override func textDidEndEditing(_ notification: Notification) {
            super.textDidEndEditing(notification)
            preventSelectAll()
        }
    }
}

//MARK: - from SwiftUI
extension TextTokenField.Native {
    func update(_ base: TextTokenField, environment: EnvironmentValues) {
        self.base = base
        self.onSubmitAction = environment.onSubmitAction

        isEnabled = environment.isEnabled
        
        if placeholderString != base.prompt {
            placeholderString = base.prompt
        }
        
        if objectValue as? [String] != base.value {
            objectValue = base.value
        }
    }
}

//MARK: - Token specific
extension TextTokenField.Native: NSTokenFieldDelegate {
    
}

//MARK: - Editing
extension TextTokenField.Native: NSControlTextEditingDelegate {
    //changed
    public func controlTextDidChange(_ obj: Notification) {
        //suggestions is clicked
        if let event = NSApp.currentEvent {
            if event.type == .leftMouseUp {
                endEditing(currentEditor()!)
                DispatchQueue.main.async { [weak self] in
                    _ = self?.becomeFirstResponder()
                }
            }
            else if event.keyCode == 36 {
                showSuggestions()
            }
        }
        
        //update swiftui value
        base.value = (objectValue as? [String]) ?? []
    }
    
    //keyboard actions
    @objc public func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        switch commandSelector {
        //up/down
        case #selector(NSResponder.moveUp(_:)), #selector(NSResponder.moveDown(_:)):
            if let field = control as? Self {
                field.showSuggestions()
            }
            return true
        
        default:
            return false
        }
    }
    
    //suggestions
    public func control(_ control: NSControl, textView: NSTextView, completions words: [String], forPartialWordRange charRange: NSRange, indexOfSelectedItem index: UnsafeMutablePointer<Int>) -> [String] {
        index.initialize(to: -1)
        let filter = textView.string.localizedLowercase.trimmingCharacters(in: .whitespacesAndNewlines)
        return base.suggestions
            .filter { !base.value.contains($0) }
            .filter { charRange.length == 0 || $0.localizedLowercase.contains(filter) }
    }
}
#endif
