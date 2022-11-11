import SwiftUI
import API

struct SettingsScene: View {
    @EnvironmentObject private var settings: SettingsRouter
    @EnvironmentObject private var dispatch: Dispatcher
    
    var body: some View {
        NavigationStack(path: $settings.path) {
            Button("Logout") {
                dispatch.sync(AuthAction.logout)
            }
        }
    }
}

extension SettingsScene {
    struct Attach: ViewModifier {
        @StateObject private var settings = SettingsRouter()
        
        func body(content: Content) -> some View {
            content
                .sheet(isPresented: $settings.isPresented) {
                    SettingsScene()
                }
                .environmentObject(settings)
        }
    }
}
