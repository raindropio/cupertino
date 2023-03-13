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
            .storeProvider(store)
    }
}
