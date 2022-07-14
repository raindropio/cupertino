import SwiftUI

#if os(macOS)
struct MenuBarScene: View {
    @StateObject private var router = Router()
    
    var body: some View {
        RouterView(index: .search)
            .environmentObject(router)
            .frame(minWidth: 400, minHeight: 400)
    }
}
#endif
