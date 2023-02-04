import SwiftUI
import API
import UI
import Features

extension PreviewScreen.Toolbar {
    struct Action: View {
        @EnvironmentObject private var page: WebPage
        @EnvironmentObject private var r: RaindropsStore
                
        private var id: Raindrop.ID? {
            guard let url = page.url else { return nil }
            return r.state.item(url)?.id
        }
        
        var body: some View {
            Memorized(id: id, url: page.url)
        }
    }
}

extension PreviewScreen.Toolbar.Action {
    fileprivate struct Memorized: View {
        @State private var show = false
        var id: Raindrop.ID?
        var url: URL?
        
        var actionButton: some View {
            Group {
                if id != nil {
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
                .buttonBorderShape(.capsule)
                .tint(.accentColor)
                .fontWeight(.semibold)
        }
        
        var body: some View {
            actionButton
            .popover(isPresented: $show) {
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
