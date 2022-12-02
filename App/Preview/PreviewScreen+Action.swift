import SwiftUI
import API
import UI
import Common

extension PreviewScreen {
    struct Action: ViewModifier {
        @ObservedObject var page: WebPage
        var raindrop: Raindrop
        
        @State private var edit = false
        @State private var create = false
        
        var editButton: some View {
            Button { edit = true } label: {
                Text("Edit").padding(1)
            }
                .buttonStyle(.bordered)
                .popover(isPresented: $edit) {
                    RaindropStack(raindrop)
                        .frame(idealWidth: 400, idealHeight: 600)
                }
        }
        
        var createButton: some View {
            Button{ create = true } label: {
                Label("Add", systemImage: "star.fill").padding(1)
                    .labelStyle(.titleAndIcon)
            }
                .buttonStyle(.borderedProminent)
                .popover(isPresented: $create) {
                    
                }
        }

        func body(content: Content) -> some View {
            let saved = !page.canGoBack || page.url == raindrop.link
            
            content.toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Group {
                        if saved {
                            editButton
                        } else {
                            createButton
                        }
                    }
                        .transition(.opacity)
                        .animation(.default, value: saved)
                        .tint(.accentColor)
                        .font(.headline)
                        .controlSize(.small)
                }
            }
        }
    }
}
