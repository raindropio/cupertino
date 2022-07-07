import SwiftUI

struct SettingsRow: View {
    var page: SettingsPage
    
    var body: some View {
        Label {
            Text(page.title)
        } icon: {
            Image(systemName: page.systemImage)
                .imageScale(.large)
        }
        .tag(page)
    }
}
