import SwiftUI
import API
import UI

public struct EditRaindropScreen: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.dismiss) private var dismiss

    @State var raindrop: Raindrop
    
    public init(raindrop: Raindrop) {
        self._raindrop = State(initialValue: raindrop)
    }
    
    public var body: some View {
        Form {
            RaindropFields(raindrop: $raindrop)
            
            ActionButton(role: .destructive) {
                if raindrop.collection == -99 {
                    try await dispatch(RaindropsAction.delete(raindrop.id))
                } else {
                    raindrop.collection = -99
                }
                dismiss()
            } label: {
                Text("Delete").frame(maxWidth: .infinity)
            }
        }
            .navigationTitle("Edit bookmark")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onDisappear {
                dispatch.sync(RaindropsAction.update(raindrop))
            }
    }
}
