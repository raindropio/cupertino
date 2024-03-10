import SwiftUI
import API
import Backport
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
            .backport.scrollBounceBehavior(.basedOnSize, axes: .vertical)
            .animation(.default, value: raindrop.collection)
            .modifier(Toolbar(raindrop: $raindrop))
            .navigationTitle((raindrop.isNew ? "New" : "Edit") + " \(raindrop.type.single.localizedLowercase)")
            #if canImport(UIKit)
            .navigationBarTitleDisplayMode(.inline)
            ._safeAreaInsets(.init(top: -15, leading: 0, bottom: 0, trailing: 0))
            #endif
            .toolbar {
                if raindrop.isNew {
                    ToolbarItem(placement: .confirmationAction) {
                        SubmitButton {
                            Text("Save")
                                .padding(.horizontal, 3)
                        }
                            #if canImport(UIKit)
                            .buttonBorderShape(.capsule)
                            #endif
                    }
                }
            }
            .onSubmit(commit)
    }
}
