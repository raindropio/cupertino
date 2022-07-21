#if os(macOS)
import SwiftUI
import AppKit
import Algorithms

@available(macOS 13.0, *)
struct PlatformTokenField<FieldLabel: View>: View {
    @Binding public var value: [String]
    var prompt: String
    var suggestions: [String]
    var label: (() -> FieldLabel)?
    
    var body: some View {
        LabeledContent {
            NativeTokenField(value: $value, prompt: prompt, suggestions: suggestions)
        } label: {
            if let label {
                label()
            } else {
                Text("")
            }
        }
            .labeledContentStyle(LabeledContentStyleFix())
    }
}

struct NativeTokenField: NSViewRepresentable {
    @Binding public var value: [String]
    var prompt: String
    var suggestions: [String]
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeNSView(context: Context) -> NativeView {
        let tokenField = NativeView()
        tokenField.delegate = context.coordinator

        //appearance
        tokenField.tokenStyle = .squared
        tokenField.isBezeled = false
        tokenField.drawsBackground = false
        tokenField.controlSize = {
            switch context.environment.controlSize {
            case .large: return .large
            case .mini: return .mini
            case .small: return .small
            default: return .regular
            }
        }()
        tokenField.completionDelay = 0
//        tokenField.alignment = .right
        
        //font
        tokenField.font = NSFont.systemFont(ofSize: NSFont.systemFontSize(for: tokenField.controlSize))
        
        //values
        tokenField.placeholderString = prompt
        tokenField.objectValue = value.map { Token($0) }
        
        return tokenField
    }
    
    public func updateNSView(_ nsView: NativeView, context: Context) {
        nsView.objectValue = value.map { Token($0) }
        context.coordinator.update(self)
    }
    
    final class Coordinator: NSObject, NSTokenFieldDelegate {
        private var parent: NativeTokenField

        public init(_ parent: NativeTokenField) {
            self.parent = parent
        }
        
        public func update(_ parent: NativeTokenField) {
            self.parent = parent
        }
        
        //helpers
        public func getValue(_ tokenField: NSTokenField) -> [String] {
            (tokenField.objectValue as? [Any])?.compactMap{ ($0 as? Token)?.text } ?? []
        }
        
        public func getSubstring(_ tokenField: NSTokenField) -> String {
            (tokenField.objectValue as? [Any])?.compactMap { $0 as? String }.first ?? ""
        }
                
        //end editing
        func controlTextDidEndEditing(_ obj: Notification) {
            if let tokenField = obj.object as? NSTokenField {
                parent.value = tokenField.stringValue
                    .split(separator: ",")
                    .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter{ !$0.isEmpty }
                    .uniqued { $0 }
            }
        }
        
        //text change
        func controlTextDidChange(_ obj: Notification) {
            if let field = obj.object as? NSTokenField {
                //suggestion clicked
                if let event = NSApp.currentEvent, event.type == .leftMouseUp{
                    field.stringValue += ","
                }
            }
        }
        
        //token label
        func tokenField(
            _ tokenField: NSTokenField,
            displayStringForRepresentedObject representedObject: Any
        ) -> String? {
            (representedObject as? Token)?.text
        }
        
        //validation
        func tokenField(
            _ tokenField: NSTokenField,
            shouldAdd tokens: [Any],
            at index: Int
        ) -> [Any] {
            let existing = getValue(tokenField)
            return tokens
                .compactMap { $0 as? String }
                .filter { !existing.contains($0) }
                .map { Token($0) }
        }
        
        //suggestions list
        func control(
            _ control: NSControl,
            textView: NSTextView,
            completions words: [String],
            forPartialWordRange charRange: NSRange,
            indexOfSelectedItem index: UnsafeMutablePointer<Int>
        ) -> [String] {
            guard let tokenField = control as? NSTokenField else {
                return []
            }
            
            let query = getSubstring(tokenField)
            
            var tokens = TokenFieldUtils.filter(
                parent.suggestions,
                value: getValue(tokenField),
                by: query
            )
            
            if let first = tokens.first, !first.starts(with: query) {
                tokens.insert(query, at: 0)
            }
            
            return tokens
        }
        
        //keyboard actions
        @objc func control(
            _ control: NSControl,
            textView: NSTextView,
            doCommandBy commandSelector: Selector
        ) -> Bool {
            switch commandSelector {
            //up/down
            case #selector(NSResponder.moveUp(_:)), #selector(NSResponder.moveDown(_:)):
                if let field = control as? NSTokenField {
                    field.currentEditor()?.complete(nil)
                }
                return true
            
            default:
                return false
            }
        }
    }
    
    class NativeView: NSTokenField {
        func preventSelectAll() {
            currentEditor()?.selectedRange = NSMakeRange(stringValue.count, 0)
        }
        
        override func becomeFirstResponder() -> Bool {
            super.becomeFirstResponder()
            preventSelectAll()
            
            return true
        }
        
        override func textDidEndEditing(_ notification: Notification) {
            super.textDidEndEditing(notification)
            preventSelectAll()
        }
    }
}

fileprivate struct Token {
    var text: String
    init(_ text: String) { self.text = text }
}
#endif
