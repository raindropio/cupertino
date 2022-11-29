import SwiftUI

public struct URLField {
    @State private var temp = ""
    
    var title: String
    @Binding var value: URL
    
    public init(_ title: String = "", value: Binding<URL>) {
        self.title = title
        self._value = value
    }
}

extension URLField: View {
    public var body: some View {
        TextField(title, text: $temp)
            .task(id: value) { temp = value.absoluteString }
            .task(id: temp) { value = URL(string: temp) ?? value }
            .keyboardType(.URL)
            .textContentType(.URL)
            .textInputAutocapitalization(.never)
            .truncationMode(.head)
            .disableAutocorrection(true)
    }
}
