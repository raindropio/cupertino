import Foundation
import FirebaseCore
import FirebaseMessaging
import Combine

final public class FCM: NSObject {
    static public let shared = FCM()
    let token: PassthroughSubject<String, Never> = PassthroughSubject()
    let messages: PassthroughSubject<[AnyHashable : Any], Never> = PassthroughSubject()

    public func start() {
        //init firebase
        FirebaseApp.configure()
        
        //listen for native push notifications
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound],
            completionHandler: { _, _ in }
        )
        
        //get token and listen for changes
        Messaging.messaging().delegate = self
        reloadToken()
    }
    
    public func reloadToken() {
        Messaging.messaging().token { token, error in
            if let token {
                self.token.send(token)
            }
        }
    }
    
    public func setAPNSToken(deviceToken: Data) {
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }
    
    public func handleNotification(userInfo: [AnyHashable: Any]) {
        messages.send(userInfo)
    }
}

extension FCM: UNUserNotificationCenterDelegate {
    @MainActor
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        handleNotification(userInfo: response.notification.request.content.userInfo)
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.badge, .banner, .list, .sound]
    }
}

extension FCM: MessagingDelegate {
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken {
            self.token.send(fcmToken)
        }
    }
}
