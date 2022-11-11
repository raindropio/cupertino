import SwiftUI
import API

struct AuthGroup<A: View, N: View>: View {
    @EnvironmentObject private var user: UserStore
    @EnvironmentObject private var dispatch: Dispatcher
    
    var authorized: () -> A
    var notAuthorized: () -> N

    var body: some View {
        Group {
            if user.state.authorized {
                authorized()
            } else {
                notAuthorized()
            }
        }
            .task(priority: .background) {
                try? await dispatch(UserAction.reload)
            }
    }
}
