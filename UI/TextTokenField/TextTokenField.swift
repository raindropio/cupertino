import SwiftUI

public struct TextTokenField {
    @Binding var value: [String]
    var suggestions: [String]
    var prompt: String
    
    public init(
        value: Binding<[String]>,
        suggestions: [String] = [],
        prompt: String = ""
    ) {
        self._value = value
        self.suggestions = suggestions
        self.prompt = prompt
    }
}

#if canImport(UIKit)
extension TextTokenField: UIViewRepresentable {
    public func makeUIView(context: Context) -> Native {
        .init(self, environment: context.environment)
    }
    
    public func updateUIView(_ view: Native, context: Context) {
        view.update(self, environment: context.environment)
    }
}
#else
extension TextTokenField: NSViewRepresentable {
    public func makeNSView(context: Context) -> Native {
        .init(self, environment: context.environment)
    }
    
    public func updateNSView(_ view: Native, context: Context) {
        view.update(self, environment: context.environment)
    }
}
#endif
