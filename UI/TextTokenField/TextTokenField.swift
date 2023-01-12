import SwiftUI

public struct TextTokenField: UIViewRepresentable {
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
    
    public func makeUIView(context: Context) -> Native {
        .init(self, environment: context.environment)
    }
    
    public func updateUIView(_ view: Native, context: Context) {
        view.update(self, environment: context.environment)
    }
}
