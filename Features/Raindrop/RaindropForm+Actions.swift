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
                SubmitButton("Save")
            } else {
                ConfirmButton(role: .destructive) {
                    Button(
                        raindrop.collection == -99 ? "Delete permanently" : "Move bookmark to Trash",
                        role: .destructive
                    ) {
                        raindrop.collection = -99
                        dispatch.sync(RaindropsAction.delete(raindrop.id))
                        dismiss()
                    }
                } label: {
                    Text("Delete")
                        .frame(maxWidth: .infinity)
                }
                
                Section {} header: {
                    (
                        Text("Created ") + Text(raindrop.created, formatter: .shortDateTime) + Text("\n") +
                        Text("Last modified ") + Text(raindrop.lastUpdate, formatter: .shortDateTime)
                    )
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .textCase(.none)
                }
            }
        }
    }
}
