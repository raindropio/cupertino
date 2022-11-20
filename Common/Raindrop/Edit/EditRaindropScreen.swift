import SwiftUI
import API

public struct EditRaindropScreen: View {
    @Environment(\.dismiss) private var dismiss

    @State var raindrop: Raindrop
    
    public init(raindrop: Raindrop) {
        self._raindrop = State(initialValue: raindrop)
    }
    
    public var body: some View {
        Form {
            RaindropFields(raindrop: $raindrop)
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
    }
}
