import SwiftUI
import API
import UI

struct SettingsLogout: View {
    @EnvironmentObject private var dispatch: Dispatcher

    var body: some View {
        ActionButton(role: .destructive) {
            try await dispatch(AuthAction.logout)
        } label: {
            Text("Logout").frame(maxWidth: .infinity)
        }
    }
}
