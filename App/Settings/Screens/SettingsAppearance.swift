import SwiftUI

struct SettingsAppearance: View {
    var body: some View {
        List {
            #if canImport(UIKit)
            AppIcon()
            #endif
        }
            .listStyle(.plain)
            .navigationTitle("Appearance")
    }
}
