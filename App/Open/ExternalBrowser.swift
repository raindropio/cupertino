import SwiftUI
import API
import UI

struct ExternalBrowser: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.dismiss) private var dismiss
    
    var raindrop: Raindrop
    
    var body: some View {
        ZStack {}
            .navigationTitle(raindrop.title)
            .toolbarRole(.editor)
            .onAppear {
                dismiss()
                openURL(raindrop.link)
            }
    }
}
