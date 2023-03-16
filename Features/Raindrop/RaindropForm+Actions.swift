import SwiftUI
import API
import UI

extension RaindropForm {
    struct Actions: View {
        @EnvironmentObject private var dispatch: Dispatcher
        @Environment(\.dismiss) private var dismiss

        @Binding var raindrop: Raindrop

        var body: some View {
            if raindrop.isNew {
                #if canImport(UIKit)
                SubmitButton("Save")
                #endif
            } else {
                ActionButton(role: .destructive) {
                    try await dispatch(RaindropsAction.delete(raindrop.id))
                    dismiss()
                } label: {
                    Text(raindrop.collection == -99 ? "Delete" : "Move to Trash")
                        .frame(maxWidth: .infinity)
                }
                    .tint(.red)
                    .buttonStyle(.borderless)
                
                Section {
                    (
                        Text("Created ") + Text(raindrop.created, formatter: .shortDateTime) + Text("\n") +
                        Text("Last modified ") + Text(raindrop.lastUpdate, formatter: .shortDateTime)
                    )
                    .fixedSize()
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .textCase(.none)
                    .foregroundStyle(.tertiary)
                    .font(.subheadline)
                }
                    .clearSection()
            }
        }
    }
}
