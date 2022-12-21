import SwiftUI
import API
import UI

struct SettingsTheme: View {
    @AppStorage("theme") private var theme: PreferredTheme = .default
    
    var body: some View {
        Picker(selection: $theme) {
            ForEach(PreferredTheme.allCases, id: \.self) {
                Text($0.title)
            }
        } label: {
            Label("Theme", systemImage: "circle.lefthalf.filled").tint(.primary)
        }
    }
}
