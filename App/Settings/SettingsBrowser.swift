import SwiftUI
import API
import UI

struct SettingsBrowser: View {
    @AppStorage("browser") private var browser: PreferredBrowser = .default
    
    var body: some View {
        Picker(selection: $browser) {
            ForEach(PreferredBrowser.allCases, id: \.self) {
                Text($0.title)
            }
        } label: {
            Label("Browser", systemImage: "safari").tint(.primary)
        }
    }
}
