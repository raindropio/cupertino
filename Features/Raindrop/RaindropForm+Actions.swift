import SwiftUI
import API
import UI

extension RaindropForm {
    struct Actions: View {
        @EnvironmentObject private var dispatch: Dispatcher
        @Environment(\.dismiss) private var dismiss
        @State private var highlights = false

        @Binding var raindrop: Raindrop

        var body: some View {
            Section {} header: {
                ControlGroup {
                    //important
                    Button { raindrop.important.toggle() } label: {
                        Image(systemName: "heart")
                    }
                        .symbolVariant(raindrop.important ? .fill : .none)
                        .tint(raindrop.important ? .accentColor : .secondary)
                    
                    //highlights
                    Button { highlights.toggle() } label: {
                        Image(systemName: Filter.Kind.highlights.systemImage)
                    }
                        .symbolVariant(!raindrop.highlights.isEmpty ? .fill : .none)
                        .tint(!raindrop.highlights.isEmpty ? .accentColor : .secondary)
                        .navigationDestination(isPresented: $highlights) {
                            RaindropHighlights($raindrop)
                        }
                    
                    //delete
                    if !raindrop.isNew {
                        ActionButton(role: .destructive, confirm: false) {
                            try await dispatch(RaindropsAction.delete(raindrop.id))
                            dismiss()
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
                    .imageScale(.large)
                    .controlGroupStyle(.horizontal)
                    .controlSize(.large)
                    .padding(.vertical, 8)
                    .cornerRadius(8)
            } footer: {
                if !raindrop.isNew {
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
                .clearSection()
        }
    }
}
