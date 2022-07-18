import SwiftUI
import SwiftUIX
import Algorithms

public struct TokenField<FieldLabel: View>: View {
    @Binding public var value: [String]
    public var prompt: String = ""
    public var suggestions: [String] = []
    public var label: (() -> FieldLabel)?
    
    public init(_ value: Binding<[String]>, prompt: String = "", suggestions: [String] = [], label: (() -> FieldLabel)?) {
        self._value = value
        self.prompt = prompt
        self.suggestions = suggestions
        self.label = label
    }

    public var body: some View {
        PlatformTokenField(
            value: $value,
            prompt: prompt,
            suggestions: suggestions,
            label: label
        )
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
            let find = query.localizedLowercase.trimmingCharacters(in: .whitespacesAndNewlines)
                        
            return suggestions
                .filter { $0.localizedLowercase.contains(find) && !value.contains($0) }
                .sorted { return $0 < $1 }
                .uniqued { $0 }
        }
    }
}
