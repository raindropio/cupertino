import SwiftUI

public struct URLField {
    @State private var temp = ""
    
    var title: String
    @Binding var value: URL?
    var prompt: Text?
    
    public init(_ title: String = "", value: Binding<URL>, prompt: Text? = nil) {
        self.title = title
        self._value = .init(get: {
            value.wrappedValue
        }, set: {
            if let url = $0 {
                value.wrappedValue = url
            }
        })
        self.prompt = prompt
    }
    
    public init(_ title: String = "", value: Binding<URL?>, prompt: Text? = nil) {
        self.title = title
        self._value = value
        self.prompt = prompt
    }
}

extension URLField: View {
    public var body: some View {
        TextField(title, text: $temp, prompt: prompt)
            .task(id: value) { temp = value?.absoluteString ?? "" }
            .task(id: temp) { value = URL(string: temp) }
            #if os(iOS)
            .keyboardType(.URL)
            .textContentType(.URL)
            .textInputAutocapitalization(.never)
            #endif
            .disableAutocorrection(true)
    }
}
