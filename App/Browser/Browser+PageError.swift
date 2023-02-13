import SwiftUI
import API
import UI
import Features

extension Browser {
    struct PageError: ViewModifier {
        @EnvironmentObject private var app: AppRouter

        @ObservedObject var page: WebPage
        @Binding var raindrop: Raindrop

        func body(content: Content) -> some View {
            content.overlay {
                Group {
                    if let error = page.error {
                        EmptyState("Error", message: error.localizedDescription) {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundStyle(.yellow)
                        } actions: {
                            Button(action: page.reload) {
                                Label("Reload", systemImage: "arrow.clockwise")
                            }

                            if raindrop.cache != nil {
                                Button {
                                    app.navigate(raindrop: raindrop.id, mode: .cache)
                                } label: {
                                    Label("Open permanent copy", systemImage: "clock.arrow.circlepath")
                                }
                                    .buttonStyle(.borderedProminent)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
            }
        }
    }
}
