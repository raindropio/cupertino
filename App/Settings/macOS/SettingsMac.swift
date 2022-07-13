import SwiftUI

#if os(macOS)
struct SettingsMac: View {
    @EnvironmentObject private var settings: SettingsService
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
#endif
