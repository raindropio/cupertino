import SwiftUI

@main
struct RaindropApp: App {
    #if os(macOS)
    @StateObject private var settings = SettingsService()
    #endif
    
    var body: some Scene {
        //MARK: - Main Window
        WindowGroup {
            Group {
                #if os(macOS)
                MacScene()
                    .environmentObject(settings)
                #else
                switch UIDevice.current.userInterfaceIdiom {
                    case .phone:
                        PhoneScene()
                    default:
                        PadScene()
                }
                #endif
            }
        }
            #if os(macOS)
            .commands {
                SidebarCommands()
            }
            #endif
        
        //MARK: - Settings
        #if os(macOS)
        Settings {
            SettingsMac()
                .environmentObject(settings)
                .onOpenURL {
                    settings.handleDeepLink($0)
                }
        }
        #endif
    }
}
