import SwiftUI

public struct TextTokenField {
    var title: String = ""
    @Binding var value: [String]
    var suggestions: [String]
    
    public init(
        _ title: String,
        value: Binding<[String]>,
        suggestions: [String] = []
    ) {
        self.title = title
        self._value = value
        self.suggestions = suggestions
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
