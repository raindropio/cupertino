import SwiftUI
import UniformTypeIdentifiers

public struct AddDetect<V: View> {
    @State private var loading = true
    @State private var urls = Set<URL>()
    
    var items: [NSItemProvider]
    var content: (Bool, Set<URL>) -> V
    
    public init(
        _ items: [NSItemProvider],
        @ViewBuilder content: @escaping (Bool, Set<URL>) -> V
    ) {
        self.items = items
        self.content = content
    }
}

extension AddDetect {
    @Sendable
    func convert() async {
        loading = true
        
        let urls = await items.getURLs(addTypes)

        let web = urls.filter { !$0.isFileURL }
        //web urls are priority
        if !web.isEmpty {
            self.urls = web
        } else {
            self.urls = urls
        }
        
        loading = false
    }
}

extension AddDetect: View {
    public var body: some View {
        content(loading, urls)
            .task(id: items, priority: .background, convert)
    }
}
