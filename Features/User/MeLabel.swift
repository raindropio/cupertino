import SwiftUI
import API
import UI

struct MeLabel: View {
    @EnvironmentObject private var user: UserStore

    var body: some View {
        UserLabel(user.state.me)
    }
}
