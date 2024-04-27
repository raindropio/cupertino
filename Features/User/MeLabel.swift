import SwiftUI
import API
import UI

public struct MeLabel: View {
    @EnvironmentObject private var user: UserStore
    
    public init() {}

    public var body: some View {
        Memorized(user: user.state.me)
    }
}

extension MeLabel {
    fileprivate struct Memorized: View {
        var user: User?
        
        public var body: some View {
            UserRow(user)
        }
    }
}
