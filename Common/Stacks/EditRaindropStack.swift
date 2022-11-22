import SwiftUI
import API
import UI

public struct EditRaindropStack {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.dismiss) private var dismiss

    @State var raindrop: Raindrop
    
    public init(_ raindrop: Raindrop) {
        self._raindrop = State(initialValue: raindrop)
    }
}

extension EditRaindropStack: View {
    public var body: some View {
        NavigationStack {
            RaindropForm(raindrop: $raindrop, footer: formFooter)
                .navigationTitle("Edit bookmark")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") { dismiss() }
                    }
                }
        }
            .onDisappear {
                dispatch.sync(RaindropsAction.update(raindrop))
            }
    }
    
    @ViewBuilder
    func formFooter() -> some View {
        if raindrop.collection != -99 {
            Button(role: .destructive) {
                raindrop.collection = -99
                dismiss()
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
}
