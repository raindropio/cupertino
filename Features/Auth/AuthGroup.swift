import SwiftUI
import API

public struct AuthGroup<A: View, N: View>: View {
    @EnvironmentObject private var user: UserStore
    @EnvironmentObject private var dispatch: Dispatcher
    
    var authorized: () -> A
    var notAuthorized: () -> N
    
    public init(
        authorized: @escaping () -> A,
        notAuthorized: @escaping () -> N
    ) {
        self.authorized = authorized
        self.notAuthorized = notAuthorized
    }

    public var body: some View {
        Group {
            if user.state.authorized {
                authorized()
            } else {
                notAuthorized()
            }
        }
            .transition(.opacity)
            .animation(.default, value: user.state.authorized)
            .task(priority: .background) {
                try? await dispatch(UserAction.reload)
            }
    }
}

extension AuthGroup where N == EmptyView {
    public init(@ViewBuilder authorized: @escaping () -> A) {
        self.authorized = authorized
        self.notAuthorized = { EmptyView() }
    }
}
