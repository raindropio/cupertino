import SwiftUI
import SwiftUIX
import Algorithms

public struct TokenField: View {
    var title: String = ""
    @Binding public var value: [String]
    public var prompt: String = ""
    public var suggestions: [String] = []
    
    public init(_ title: String = "", value: Binding<[String]>, prompt: String = "", suggestions: [String] = []) {
        self.title = title
        self._value = value
        self.prompt = prompt
        self.suggestions = suggestions
    }

    public var body: some View {
        LabeledContent(title) {
            NativeTokenField(value: $value, prompt: prompt, suggestions: suggestions)
                .tintColor(.accentColor)
                .listRowInsets(EdgeInsets())
        }
            #if os(iOS)
            .labeledContentStyle(NativeTokenFieldLabeledContentStyle())
            #endif
    }
}

struct TokenFieldUtils {
    static func filter(_ suggestions: [String], value: [String], by query: String = "") -> [String] {
        if query.isEmpty {
            if value.isEmpty {
                return suggestions
            } else {
                return suggestions.filter { !value.contains($0) }
            }
        } else {
            let find = query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            
            return suggestions
                .filter { !value.contains(query) && $0.lowercased().contains(find) }
                .sorted { return $0 < $1 }
                .uniqued { $0 }
        }
    }
}
