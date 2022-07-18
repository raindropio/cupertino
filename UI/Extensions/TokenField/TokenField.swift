import SwiftUI
import SwiftUIX
import Algorithms

public struct TokenField: View {
    var title: String = ""
    @Binding public var value: [String]
    public var prompt: String = ""
    public var suggestions: [String] = []
    
    //MARK: - Optional actions
    private var moreButton: (() -> Void)?
    public func moreButton(_ action: (() -> Void)?) -> Self {
        var copy = self; copy.moreButton = action; return copy
    }
    
    public init(_ title: String = "", value: Binding<[String]>, prompt: String = "", suggestions: [String] = []) {
        self.title = title
        self._value = value
        self.prompt = prompt
        self.suggestions = suggestions
    }

    public var body: some View {
        LabeledContent(title) {
            NativeTokenField(value: $value, prompt: prompt, suggestions: suggestions, moreButton: moreButton)
                .tintColor(.accentColor)
                .listRowInsets(EdgeInsets())
        }
            .labeledContentStyle(NativeTokenFieldLabeledContentStyle())
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
