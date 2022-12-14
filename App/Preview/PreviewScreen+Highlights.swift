import SwiftUI
import API
import UI
import Common
import Backport

extension PreviewScreen {
    struct Highlights: ViewModifier {
        @Environment(\.horizontalSizeClass) private var sizeClass
        
        @ObservedObject var page: WebPage
        var raindrop: Raindrop?
        @Binding var showHighlights: Bool
        
        func body(content: Content) -> some View {
            if sizeClass == .regular {
                HStack(spacing: 0) {
                    content
                    
                    if showHighlights, let raindrop {
                        Divider()
                            .ignoresSafeArea()
                            .environment(\.colorScheme, page.colorScheme)
                        
//                        HighlightsStack(raindrop)
//                            .environment(\.colorScheme, page.colorScheme)
//                            .frame(maxWidth: 400)
                    }
                }
                    .animation(.default, value: showHighlights)
            } else {
                content
                    .sheet(isPresented: $showHighlights) {
//                        if let raindrop {
//                            HighlightsStack(raindrop)
//                        }
                    }
            }
        }
    }
}
