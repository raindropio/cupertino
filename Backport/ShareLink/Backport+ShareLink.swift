import SwiftUI

/// EVEN ON iOS 16 native version is buggy! so usign custom implementation
public extension Backport where Wrapped == Any {
    @ViewBuilder
    static func ShareLink(item: URL) -> some View {
        _ShareLink(item: item)
    }
}

fileprivate struct _ShareLink: View {
    var item: URL
    
    private func present() {
        //make sure to present activity like this, swiftui .sheet will not work if included inside Menu
        let window = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first?.windows.first
        let av = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            av.popoverPresentationController?.sourceView = window
            av.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 300, height: 350)
            av.popoverPresentationController?.permittedArrowDirections = [.up]
        }
        
        window?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    var body: some View {
        Button(action: present) {
            Label("Share", systemImage: "square.and.arrow.up")
        }
    }
}
