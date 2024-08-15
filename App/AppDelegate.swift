import UIKit
#if os(iOS)
import PushNotifications
#endif
import API

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppPushes.shared.start()
        #if os(iOS)
        PushNotifications.shared.start(instanceId: Constants.pusherInstanceId)
        #endif
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        #if os(iOS)
        PushNotifications.shared.registerDeviceToken(deviceToken)
        #endif
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        #if os(iOS)
        PushNotifications.shared.handleNotification(userInfo: userInfo)
        #endif
    }
}
