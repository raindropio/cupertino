import SwiftUI

struct SettingsAppearance: View {
    var body: some View {
        List {
            AppIcon()
        }
            .listStyle(.plain)
            .navigationTitle("Appearance")
    }
}
