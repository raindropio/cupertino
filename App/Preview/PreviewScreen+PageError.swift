import SwiftUI
import API
import UI
import Features
import Backport

extension PreviewScreen {
    struct PageError: ViewModifier {
        @EnvironmentObject private var page: WebPage
        @EnvironmentObject private var app: AppRouter

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

                            if let url = page.url {
                                Button {
//                                    app.replace(.preview(url, .cache))
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
