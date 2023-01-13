import SwiftUI
import API
import UI

extension RaindropStack {
    struct Dates: View {
        @Binding var raindrop: Raindrop

        var body: some View {
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
