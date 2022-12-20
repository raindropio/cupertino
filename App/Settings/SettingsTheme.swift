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

enum PreferredTheme: String, CaseIterable {
    case automatic
    case light
    case dark
    
    static var `default`: Self {
        .automatic
    }
    
    var title: String {
        switch self {
        case .automatic: return "Automatic"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .automatic: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
