import SwiftUI
import UI
import UniformTypeIdentifiers

extension FabStack {
    struct Web: View {
        @State private var url: URL?
        @Binding var items: [NSItemProvider]

        private func saveUrl() {
            if let url {
                items = [.init(item: url as NSURL, typeIdentifier: UTType.url.identifier)]
            }
        }
        
        private func onAppear() {
            if UIPasteboard.general.hasURLs {
                url = UIPasteboard.general.url
            }
        }
        
        var body: some View {
            Section("URL") {
                HStack {
                    URLField("https://", value: $url)
                        .autoFocus()
                        .onAppear(perform: onAppear)
                    
                    Button(action: saveUrl) {
                        Image(systemName: "plus")
                    }
                        .buttonStyle(.borderedProminent)
                        .fontWeight(.semibold)
                        .controlSize(.small)
                        .opacity(url == nil ? 0 : 1)
                        .scaleEffect(url == nil ? 0.5 : 1)
                        .animation(.spring(), value: url != nil)
                }
            }
                .onSubmit(saveUrl)
        }
    }
}
