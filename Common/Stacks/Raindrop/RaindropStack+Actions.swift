import SwiftUI
import API
import UI
import Backport

extension RaindropStack {
    struct Actions {
        @EnvironmentObject private var dispatch: Dispatcher
        @Environment(\.dismiss) private var dismiss
        @Binding var raindrop: Raindrop
    }
}

extension RaindropStack.Actions: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    if !raindrop.isNew {
                        ConfirmButton(role: .destructive) {
                            Button(
                                raindrop.collection == -99 ? "Delete permanently" : "Move bookmark to Trash",
                                role: .destructive
                            ) {
                                raindrop.collection = -99
                                dispatch.sync(RaindropsAction.delete(raindrop.id))
                                dismiss()
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                            .tint(.red)
                            .labelStyle(.titleOnly)
                    }
                    
                    Spacer()
                    
                    Button { raindrop.important.toggle() } label: {
                        Label("Favorite", systemImage: "heart")
                            .symbolVariant(raindrop.important ? .fill : .none)
                    }
                        .tint(raindrop.important ? .accentColor : nil)
                }
            }
            .backport.toolbarTitleMenu {
                Picker("Type", selection: $raindrop.type) {
                    ForEach(RaindropType.allCases, id: \.single) {
                        Label($0.single, systemImage: $0.systemImage)
                            .tag($0)
                    }
                }
            }
    }
}
