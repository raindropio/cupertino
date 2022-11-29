import SwiftUI
import API
import UI

extension CreateRaindropStack {
    struct New: View {
        @EnvironmentObject private var dispatch: Dispatcher
        @Environment(\.dismiss) private var dismiss
        
        @Binding var raindrop: Raindrop
        
        var body: some View {
            NavigationStack {
                RaindropForm(raindrop: $raindrop)
                    .navigationTitle("New bookmark")
                    .navigationBarTitleDisplayMode(.inline)
                    .safeAreaInset(edge: .bottom) {
                        ActionButton {
                            try await dispatch(RaindropsAction.create(raindrop))
                            dismiss()
                        } label: {
                            Text("Save").frame(maxWidth: .infinity)
                        }
                            .buttonStyle(.borderedProminent)
                            .fontWeight(.semibold)
                            .scenePadding()
                            .background(.bar)
                    }
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel", action: dismiss.callAsFunction)
                        }
                    }
            }
        }
    }
}
