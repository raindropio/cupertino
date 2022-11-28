import SwiftUI
import API
import Common

struct Share: View {
    @StateObject private var store = Store(keychain: "7459JWM5TY.secrets")
    
    var body: some View {
        AuthGroup(
            authorized: SaveItems.init,
            notAuthorized: NoAuth.init
        )
            .environmentObject(store.dispatcher)
            .environmentObject(store.auth)
            .environmentObject(store.collections)
            .environmentObject(store.filters)
            .environmentObject(store.icons)
            .environmentObject(store.raindrops)
            .environmentObject(store.filters)
            .environmentObject(store.recent)
            .environmentObject(store.user)
    }
}
