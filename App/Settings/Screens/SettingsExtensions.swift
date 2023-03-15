import SwiftUI
import API
import UI
import Features

struct SettingsExtensions: View {
    var body: some View {
        Form {
            Share()
            #if canImport(UIKit)
            Action()
            #endif
            Safari()
        }
            .formStyle(.grouped)
            .navigationTitle("Extensions")
            #if canImport(UIKit)
            .navigationBarTitleDisplayMode(.inline)
            #endif
    }
}
