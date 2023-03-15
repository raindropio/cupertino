import SwiftUI
import API
import UI
import Features

struct SettingsExtensions: View {
    var body: some View {
        List {
            Share()
            #if canImport(UIKit)
            Action()
            #endif
            Safari()
        }
            .navigationTitle("Extensions")
            #if canImport(UIKit)
            .navigationBarTitleDisplayMode(.inline)
            #endif
    }
}
