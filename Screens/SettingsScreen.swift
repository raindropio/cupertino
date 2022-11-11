import SwiftUI
import API

struct SettingsScreen: View {
    @EnvironmentObject private var dispatch: Dispatcher
    
    var body: some View {
        Button("Logout") {
            dispatch.sync(AuthAction.logout)
        }
    }
}
