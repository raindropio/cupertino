import SwiftUI
import API
import UI
import Common
import Backport

extension PreviewScreen {
    struct Action: ViewModifier {
        @EnvironmentObject private var page: WebPage
        @EnvironmentObject private var r: RaindropsStore
                
        private var id: Raindrop.ID? {
            guard let url = page.url else { return nil }
            return r.state.item(url)?.id
        }
        
        func body(content: Content) -> some View {
            content.modifier(Memorized(id: id, url: page.url))
        }
    }
}

extension PreviewScreen.Action {
    fileprivate struct Memorized: ViewModifier {
        @State private var show = false
        var id: Raindrop.ID?
        var url: URL?
        
        func actionButton() -> some View {
            Group {
                if id != nil {
                    Button("Edit") { show = true }
                        .buttonStyle(.bordered)
                } else {
                    Button { show = true } label: {
                        Label("Add", systemImage: "plus")
                    }
                        .disabled(url == nil)
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
                    if let id {
                        RaindropStack.ById(id)
                    } else if let url {
                        RaindropStack(url)
                    }
                }
                    .frame(idealWidth: 400, idealHeight: 600)
            }
        }
    }
}
