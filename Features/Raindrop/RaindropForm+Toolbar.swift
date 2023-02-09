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
