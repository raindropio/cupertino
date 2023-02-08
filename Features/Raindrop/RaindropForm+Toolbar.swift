import SwiftUI
import API
import UI

extension RaindropForm {
    struct Toolbar {
        @EnvironmentObject private var dispatch: Dispatcher
        @Binding var raindrop: Raindrop
    }
}

extension RaindropForm.Toolbar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                //important
                ToolbarItem(placement: raindrop.isNew ? .confirmationAction : .cancellationAction) {
                    Button { raindrop.important.toggle() } label: {
                        Label("Favorite", systemImage: "heart")
                            .symbolVariant(raindrop.important ? .fill : .none)
                    }
                        .tint(raindrop.important ? .accentColor : .secondary)
                }
            }
            .toolbarTitleMenu {
                Picker("Type", selection: $raindrop.type) {
                    ForEach(RaindropType.allCases, id: \.single) {
                        Label($0.single, systemImage: $0.systemImage)
                            .tag($0)
                    }
                }
            }
    }
}
