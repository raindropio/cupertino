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
            Label("Browser", systemImage: "safari.fill").tint(.primary)
        }
    }
}

enum PreferredBrowser: String, CaseIterable {
    case inapp
    case safari
    case system
    
    static var `default`: Self {
        .inapp
    }
    
    var title: String {
        switch self {
        case .inapp: return "In App"
        case .safari: return "Safari"
        case .system: return "System default"
        }
    }
}
