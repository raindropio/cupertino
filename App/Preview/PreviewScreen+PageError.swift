import SwiftUI
import API
import UI
import Common
import Backport

extension PreviewScreen {
    struct PageError: ViewModifier {
        @ObservedObject var page: WebPage

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
                        }
                    }
                }
            }
        }
    }
}
