import SwiftUI
import API
import Features

struct Share: View {
    @StateObject private var store = Store()
    
    var body: some View {
        AuthGroup(
            authorized: Receive.init,
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
