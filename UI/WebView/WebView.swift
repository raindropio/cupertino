import SwiftUI
import Combine
import WebKit

public struct WebView {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var service: WebViewService
    var url: URL?

    public init(_ url: URL? = nil, _ service: WebViewService) {
        self.url = url
        self.service = service
    }
}

extension WebView: View {
    public var body: some View {
        let pageScheme: ColorScheme = (service.underPageBackgroundColor?.isLight ?? false) ? .light : .dark
        let overrideScheme: ColorScheme? = colorScheme != pageScheme ? pageScheme : nil
        
        ZStack(alignment: .topLeading) {
            NativeWebView(service: service, url: url)
                .ignoresSafeArea()
            
            Rectangle()
                .foregroundColor(Color(service.underPageBackgroundColor))
                .overlay(.ultraThickMaterial)
                .frame(height: 1)
                .opacity(service.prefersHiddenToolbars ? 1 : 0)
                .animation(nil, value: service.prefersHiddenToolbars)
            
            ProgressView(value: service.estimatedProgress, total: 1)
                .progressViewStyle(.simpleHorizontal)
                .opacity(service.isLoading ? 1 : 0)
                .animation(.default, value: service.isLoading)
        }
            .toolbarColorScheme(overrideScheme)
            .toolbarBackground(overrideScheme != nil ? .visible : .automatic)
            .toolbar(service.prefersHiddenToolbars ? .hidden : .automatic, for: .navigationBar, .bottomBar, .tabBar)
            .animation(.default, value: service.prefersHiddenToolbars)
    }
}
