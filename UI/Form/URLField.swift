import SwiftUI

public struct URLField {
    @State private var temp = ""
    
    var title: String
    @Binding var value: URL?
    var prompt: Text?
    var axis: Axis?
    
    public init(_ title: String = "", value: Binding<URL>, prompt: Text? = nil, axis: Axis? = nil) {
        self.title = title
        self._value = .init(get: {
            value.wrappedValue
        }, set: {
            if let url = $0 {
                value.wrappedValue = url
            }
        })
        self.prompt = prompt
        self.axis = axis
    }
    
    public init(_ title: String = "", value: Binding<URL?>, prompt: Text? = nil, axis: Axis? = nil) {
        self.title = title
        self._value = value
        self.prompt = prompt
        self.axis = axis
    }
}

extension URLField: View {
    public var body: some View {
        Group {
            if let axis {
                TextField(title, text: $temp, prompt: prompt, axis: axis)
            } else {
                TextField(title, text: $temp, prompt: prompt)
            }
        }
            .task(id: value) { temp = value?.absoluteString ?? "" }
            .task(id: temp) { value = URL(string: temp) }
            #if canImport(UIKit)
            .keyboardType(.URL)
            .textContentType(.URL)
            .textInputAutocapitalization(.never)
            #endif
            .disableAutocorrection(true)
    }
}
