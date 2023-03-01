import SwiftUI
import API
import Features

struct Main: View {
    @StateObject private var store = Store()
    
    var body: some View {
        AuthGroup(
            authorized: Receive.init,
            notAuthorized: NoAuth.init
        )
            .tint(.blue)
            .environmentObject(store.dispatcher)
            .environmentObject(store.auth)
            .environmentObject(store.collaborators)
            .environmentObject(store.collections)
            .environmentObject(store.config)
            .environmentObject(store.filters)
            .environmentObject(store.icons)
            .environmentObject(store.raindrops)
            .environmentObject(store.filters)
            .environmentObject(store.recent)
            .environmentObject(store.user)
    }
}
