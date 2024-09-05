# Firebase Cloud Messaging

## How to use?
```swift
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FCM.shared.start()
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        FCM.shared.setAPNSToken(deviceToken: deviceToken)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        FCM.shared.handleNotification(userInfo: userInfo)
    }
}
```

```swift
view
    .onFCMToken { token in
        print("fcm token", token)
    }
    .onFCMMessage { message in
        print("message", message)
    }
```
