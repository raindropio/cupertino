import SwiftUI
import API
import UI
import Features

struct SettingsExtensions: View {
    var body: some View {
        List {
            Share()
            Action()
            Safari()
        }
            .navigationTitle("Extensions")
            .navigationBarTitleDisplayMode(.inline)
    }
}
