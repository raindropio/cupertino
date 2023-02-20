import SwiftUI
import API
import UI

struct Browse: View {
    @StateObject private var page = WebPage()
    @EnvironmentObject private var r: RaindropsStore
    var url: URL
    
    private var request: WebRequest {
        .init(url)
    }
    
    var body: some View {
        Browser(page: page, start: request)
            .navigationTitle("Preview")
    }
}
