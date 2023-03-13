import SwiftUI
import API
import UI
import Features

extension Browser {
    struct PageError: ViewModifier {
        @ObservedObject var page: WebPage
        @Binding var raindrop: Raindrop

        func body(content: Content) -> some View {
            content.safeAreaInset(edge: .bottom) {
                if let error = page.error {
                    HStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.yellow)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            if !error.localizedDescription.isEmpty {
                                Text(error.localizedDescription)
                                    .foregroundStyle(.secondary)
                                    .font(.subheadline)
                            }
                            
                            if raindrop.file == nil, raindrop.cache?.status == .ready {
                                DeepLink(.raindrop(.cache(raindrop.id))) {
                                    Label("Permanent copy", systemImage: "clock.arrow.circlepath")
                                }
                                    .controlSize(.small)
                            }
                        }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button(action: page.reload) {
                            Label("Reload", systemImage: "arrow.clockwise")
                        }
                            .labelStyle(.iconOnly)
                            .buttonStyle(.borderedProminent)
                    }
                        .scenePadding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.regularMaterial)
                }
            }
        }
    }
}
