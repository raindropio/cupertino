import SwiftUI
import API
import UI
import Common
import Backport

extension PreviewScreen {
    struct Action: ViewModifier {
        @EnvironmentObject private var dispatch: Dispatcher
        @State private var edit = false
        
        @ObservedObject var page: WebPage
        var raindrop: Raindrop
        
        var editButton: some View {
            Button { edit = true } label: {
                Text("Edit").padding(1)
            }
                .buttonStyle(.bordered)
                .tint(.accentColor)
                .backport.fontWeight(.semibold)
                .controlSize(.small)
        }
        
        func body(content: Content) -> some View {
            content
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Group {
                        if !page.canGoBack {
                            editButton
                                .transition(.opacity)
                        }
                    }
                        .animation(.default, value: page.canGoBack)
                }
            }
            .sheet(isPresented: $edit) {
                RaindropStack(raindrop)
                    .frame(idealWidth: 400, idealHeight: 600)
            }
        }
    }
}
