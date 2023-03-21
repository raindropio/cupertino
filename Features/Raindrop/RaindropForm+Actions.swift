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
                Section {
                    ControlGroup {
                        Button { raindrop.important.toggle() } label: {
                            Image(systemName: "heart")
                        }
                            .symbolVariant(raindrop.important ? .fill : .none)
                            .tint(raindrop.important ? .accentColor : .secondary)
                        
                        ActionButton(role: .destructive, confirm: false) {
                            try await dispatch(RaindropsAction.delete(raindrop.id))
                            dismiss()
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                        .imageScale(.medium)
                        .controlGroupStyle(.horizontal)
                } footer: {
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
                    .scenePadding(.top)
                }
            }
        }
    }
}
