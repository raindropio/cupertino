import SwiftUI
import API
import UI

extension RaindropStack {
    struct Footer: View {
        @Environment(\.dismiss) private var dismiss
        @Binding var raindrop: Raindrop
        @Binding var loading: Bool
        
        var saveNew: some View {
            SubmitButton("Save")
        }
        
        @ViewBuilder
        var removeExisting: some View {
            if raindrop.collection != -99 {
                ConfirmButton(role: .destructive) {
                    Button("Move bookmark to Trash", role: .destructive) {
                        raindrop.collection = -99
                        dismiss()
                    }
                } label: {
                    Text("Delete").frame(maxWidth: .infinity)
                }
            }
            
            Section {} footer: {
                (
                    Text("Created ") + Text(raindrop.created, formatter: .shortDateTime) + Text("\n") +
                    Text("Last modified ") + Text(raindrop.lastUpdate, formatter: .shortDateTime)
                )
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            }
        }
        
        var body: some View {
            Group {
                if !loading {
                    if raindrop.id == 0 {
                        saveNew
                    } else {
                        removeExisting
                    }
                }
            }
                .transition(.move(edge: .bottom))
        }
    }
}
