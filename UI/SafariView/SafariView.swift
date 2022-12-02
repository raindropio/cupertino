import SwiftUI

public struct SafariView: View {
    let url: URL
    
    public init(url: URL) {
        self.url = url
    }

    public var body: some View {
        PlatformSafariView(url: url)
            .ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
            .backport.toolbarRole(.editor)
    }
}
