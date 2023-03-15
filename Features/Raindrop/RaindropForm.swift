import SwiftUI
import API
import UI

public struct RaindropForm {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.dismiss) private var dismiss
    @AppStorage("last-used-collection") private var lastUsedCollection: Int?
    
    @Binding var raindrop: Raindrop
    
    public init(_ raindrop: Binding<Raindrop>) {
        self._raindrop = raindrop
    }
}

extension RaindropForm {
    private func commit() async throws {
        if raindrop.isNew {
            lastUsedCollection = raindrop.collection
        }
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
            .formStyle(.fancy)
            .animation(.default, value: raindrop.collection)
            .modifier(Toolbar(raindrop: $raindrop))
            .submitLabel(.done)
            #if canImport(UIKit)
            .navigationTitle((raindrop.isNew ? "New" : "Edit") + " \(raindrop.type.single.localizedLowercase)")
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if canImport(AppKit)
                ToolbarItem(placement: .confirmationAction) {
                    SubmitButton("Save")
                }
                #endif
            }
            .onSubmit(commit)
    }
}
