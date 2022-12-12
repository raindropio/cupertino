import SwiftUI
import API
import UI
import Common
import Backport

extension PreviewScreen {
    struct Action: ViewModifier {
        @EnvironmentObject private var dispatch: Dispatcher
        @State private var show = false
        
        @ObservedObject var page: WebPage
        var raindrop: Raindrop?
        
        func actionButton() -> some View {
            Group {
                if raindrop != nil {
                    Button("Edit") { show = true }
                        .buttonStyle(.bordered)

                } else {
                    Button { show = true } label: {
                        Label("Add", systemImage: "plus")
                    }
                        .buttonStyle(.borderedProminent)
                }
            }
                .labelStyle(.titleAndIcon)
                .controlSize(.small)
                .tint(.accentColor)
                .backport.fontWeight(.semibold)
        }
        
        func body(content: Content) -> some View {
            content
            .toolbar {
                ToolbarItem(
                    placement: .primaryAction,
                    content: actionButton
                )
            }
            .sheet(isPresented: $show) {
                Group {
                    if let raindrop {
                        RaindropStack(raindrop)
                    } else if let url = page.url {
                        RaindropStack(url)
                    }
                }
                    .frame(idealWidth: 400, idealHeight: 600)
            }
        }
    }
}
