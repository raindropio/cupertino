import SwiftUI

public extension View {
    func safariView(isPresented: Binding<Bool>, url: URL, button: SafariActivityButton? = nil) -> some View {
        sheet(isPresented: isPresented) {
            PlatformSafariView(url: url, button: button)
                .ignoresSafeArea()
        }
    }
}
