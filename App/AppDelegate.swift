import UIKit
import PushNotifications
import API
import Sentry

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SentrySDK.start { options in
            options.dsn = Constants.sentryDsn
            //options.debug = true
            options.tracesSampleRate = 0.1
            options.enableCaptureFailedRequests = false
        }
        
        AppPushes.shared.start()
        PushNotifications.shared.start(instanceId: Constants.pusherInstanceId)
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PushNotifications.shared.registerDeviceToken(deviceToken)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        PushNotifications.shared.handleNotification(userInfo: userInfo)
    }
}
