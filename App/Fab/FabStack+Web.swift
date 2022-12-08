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
            URLField("https://", value: $url)
                .autoFocus()
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done", action: saveUrl)
                            .disabled(url == nil)
                    }
                }
                .onSubmit(saveUrl)
                .onAppear(perform: onAppear)
        }
    }
}
