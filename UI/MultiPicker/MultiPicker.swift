import SwiftUI

public struct MultiPicker<S: Hashable, C: View, SU: View> {
    @Environment(\.multiPickerStyle) private var style
    
    var title: String
    var selection: Binding<Set<S>>
    var content: (S) -> C
    
    var suggestions: ((_ filter: String) -> SU)?
    
    public init(
        _ title: String,
        selection: Binding<Set<S>>,
        content: @escaping (S) -> C,
        suggestions: ((_ filter: String) -> SU)? = nil
    ) {
        self.title = title
        self.selection = selection
        self.content = content
        self.suggestions = suggestions
    }
}

extension MultiPicker where S == String {
    public init(
        _ title: String,
        selection: Binding<[S]>,
        content: @escaping (S) -> C,
        suggestions: ((_ filter: String) -> SU)? = nil
    ) {
        self.title = title
        self.selection = .init {
            Set(selection.wrappedValue)
        } set: {
            selection.wrappedValue = $0.sorted()
        }
        self.content = content
        self.suggestions = suggestions
    }
}

extension MultiPicker: View {
    public var body: some View {
        switch style {
        case .automatic, .menu:
            MultiPickerMenu(title: title, selection: selection, content: content, suggestions: suggestions)
            
        case .inline:
            MultiPickerInline(selection: selection, content: content, suggestions: suggestions)
        }
    }
}
