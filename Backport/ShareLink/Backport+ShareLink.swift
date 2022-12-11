import SwiftUI

@available(iOS, deprecated: 16.0)
public extension Backport where Wrapped == Any {
    struct ShareLink {
        @State private var show = false
        private var item: URL
        
        public init(
            item: URL
        ) {
            self.item = item
        }
    }
}

extension Backport.ShareLink: View {
    public var body: some View {
        if #available(iOS 16, *) {
            SwiftUI.ShareLink(item: item)
        } else {
            Button { show = true } label: {
                Image(systemName: "square.and.arrow.up")
            }
                .sheet(isPresented: $show) {
                    PlatformShareLink(item: item)
                        .ignoresSafeArea()
                        .backport.presentationDetents([.medium, .large])
                        .backport.presentationDragIndicator(.hidden)
                }
        }
    }
}

fileprivate struct PlatformShareLink: UIViewControllerRepresentable {
    var item: URL
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}
