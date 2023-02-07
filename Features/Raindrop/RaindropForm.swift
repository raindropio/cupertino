import SwiftUI
import API
import UI

public struct RaindropForm {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.dismiss) private var dismiss
    
    @Binding var raindrop: Raindrop
    
    public init(_ raindrop: Binding<Raindrop>) {
        self._raindrop = raindrop
    }
}

extension RaindropForm {
    private func commit() async throws {
        try await dispatch(raindrop.isNew ? RaindropsAction.create(raindrop) : RaindropsAction.update(raindrop))
        dismiss()
    }
}

extension RaindropForm: View {
    public var body: some View {
        Form {
            Fields(raindrop: $raindrop)
            Actions(raindrop: $raindrop)
        }
            .modifier(Toolbar(raindrop: $raindrop))
            .submitLabel(.done)
            .onSubmit(commit)
            .navigationTitle((raindrop.isNew ? "New" : "Edit") + " \(raindrop.type.single.localizedLowercase)")
            .navigationBarTitleDisplayMode(.inline)
    }
}
