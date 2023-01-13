import SwiftUI
import API
import UI

public struct MeLabel: View {
    @EnvironmentObject private var user: UserStore
    
    public init() {}

    public var body: some View {
        UserRow(user.state.me)
    }
}
