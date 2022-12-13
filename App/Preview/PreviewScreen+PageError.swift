import SwiftUI
import API
import UI
import Common
import Backport

extension PreviewScreen {
    struct PageError: ViewModifier {
        @EnvironmentObject private var app: AppRouter

        @ObservedObject var page: WebPage
        var raindrop: Raindrop?

        func body(content: Content) -> some View {
            content
            .overlay {
                Group {
                    if let error = page.error {
                        EmptyState("Error", message: error.localizedDescription) {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundStyle(.yellow)
                        } actions: {
                            Button(action: page.reload) {
                                Label("Reload", systemImage: "arrow.clockwise")
                            }
                                                        
                            if let id = raindrop?.id, raindrop?.cache != nil {
                                Button {
                                    app.replace(.preview(id, .cache))
                                } label: {
                                    Label("Open permanent copy", systemImage: "clock.arrow.circlepath")
                                }
                                    .buttonStyle(.borderedProminent)
                                    .backport.fontWeight(.semibold)
                            }
                        }
                    }
                }
            }
        }
    }
}
