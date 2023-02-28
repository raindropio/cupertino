import SwiftUI
import API

public struct ProGroup<P: View, F: View>: View {
    @EnvironmentObject private var user: UserStore
    
    var pro: () -> P
    var free: () -> F
    
    public init(
        pro: @escaping () -> P,
        free: @escaping () -> F
    ) {
        self.pro = pro
        self.free = free
    }

    public var body: some View {
        if user.state.me?.pro == true {
            pro()
        } else {
            free()
        }
    }
}

extension ProGroup where F == EmptyView {
    public init(
        pro: @escaping () -> P
    ) {
        self.pro = pro
        self.free = { EmptyView() }
    }
}
