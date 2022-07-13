import SwiftUI

#if os(macOS)
struct MacScene: View {
    @StateObject private var router = Router()
    
    var body: some View {
        SplitViewScene()
            .environmentObject(router)
            .onOpenURL {
                router.handleDeepLink($0)
            }
    }
}
#endif
