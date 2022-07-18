#if os(macOS)
import SwiftUI
import AppKit
import Algorithms

struct NativeTokenFieldLabeledContentStyle: LabeledContentStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            configuration.content
                .alignmentGuide(.controlAlignment) { $0[.leading] }
        }
            .alignmentGuide(.leading) { $0[.controlAlignment] }
    }
}

extension HorizontalAlignment {
    private enum ControlAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.center]
        }
    }
    internal static let controlAlignment = HorizontalAlignment(ControlAlignment.self)
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
        tokenField.objectValue = value
        
        return tokenField
    }
    
    public func updateNSView(_ nsView: NativeView, context: Context) {
        nsView.objectValue = value
        context.coordinator.update(self)
    }
    
    final class Coordinator: NSObject, NSTokenFieldDelegate {
        var parent: NativeTokenField

        init(_ parent: NativeTokenField) {
            self.parent = parent
        }
        
        func update(_ parent: NativeTokenField) {
            self.parent = parent
        }
                
        //end editing
        func controlTextDidEndEditing(_ obj: Notification) {
            if let field = obj.object as? NativeView,
               let tokens = field.objectValue as? [String] {
                parent.value = tokens.uniqued { $0 }
            }
        }
        
        //text change
        func controlTextDidChange(_ obj: Notification) {
            if let field = obj.object as? NativeView {
                //suggestions is clicked
                if let event = NSApp.currentEvent, event.type == .leftMouseUp{
                    field.stringValue += ","
                }
            }
        }
        
        //suggestions list
        func control(_ control: NSControl, textView: NSTextView, completions words: [String], forPartialWordRange charRange: NSRange, indexOfSelectedItem index: UnsafeMutablePointer<Int>) -> [String] {
            let value = (control as? NativeView)?.objectValue as? [String] ?? []
            let query = textView.string.isEmpty ? "" : (value.last ?? "")

            var tokens = TokenFieldUtils.filter(
                parent.suggestions,
                value: value,
                by: query
            )
            
            if let first = tokens.first, !first.starts(with: query) {
                tokens.insert(query, at: 0)
            }

            return tokens
        }
        
        //keyboard actions
        @objc func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            switch commandSelector {
            //up/down
            case #selector(NSResponder.moveUp(_:)), #selector(NSResponder.moveDown(_:)):
                if let field = control as? NativeView {
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

#endif
