import SwiftUI
import API
import UI
import Features

struct SettingsExtensions: View {
    var body: some View {
        Form {
            Share()
            
            Safari()
            
            #if canImport(UIKit)
            Action()
            #endif
        }
            .navigationTitle("Extensions")
    }
}
