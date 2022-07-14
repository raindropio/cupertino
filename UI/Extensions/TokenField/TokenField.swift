import SwiftUI
import SwiftUIX

public struct TokenField: View {
    var title: String = ""
    @Binding public var value: [String]
    public var prompt: String = ""
    public var suggestions: (_ text: String) -> [TokenFieldSuggestion]
    
    public init(_ title: String, value: Binding<[String]>, prompt: String, suggestions: @escaping (_ text: String) -> [TokenFieldSuggestion]) {
        self.title = title
        self._value = value
        self.prompt = prompt
        self.suggestions = suggestions
    }

    public var body: some View {
        NativeTokenField(value: $value, prompt: prompt, suggestions: suggestions)
            .listRowInsets(EdgeInsets())
    }
}

public enum TokenFieldSuggestion {
    case text(String)
    case section(String)
}
