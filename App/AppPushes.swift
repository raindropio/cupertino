import UIKit
import PushNotifications
import API

final class AppPushes: NSObject {
    static let shared = AppPushes()
    var pressed: Pressed?
    
    func start() {
        UNUserNotificationCenter.current().delegate = self
    }
}

//MARK: - Types
extension AppPushes {
    enum Pressed: Equatable, Codable {
        case raindrop(/*id: Raindrop.ID, collectionRef: Int,*/ link: URL)
    }
}

extension Notification.Name {
    static let pushPressed = Notification.Name("push-pressed")
}

//MARK: - Receive Push Notification
extension AppPushes: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        #if DEBUG
        print("Push pressed", response.notification.request.content.userInfo)
        #endif
        
        if
            let aps = response.notification.request.content.userInfo["aps"] as? [String: Any],
            let data = aps["data"],
            let json = try? JSONSerialization.data(withJSONObject: data) {
            pressed = try? JSONDecoder().decode(Pressed.self, from: json)
            NotificationCenter.default.post(name: .pushPressed, object: nil)
        } else {
            pressed = nil
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .list, .sound])
    }
}

//MARK: - User Registration
extension AppPushes {
    func link(userId: User.ID) {
        PushNotifications.shared.registerForRemoteNotifications()
        PushNotifications.shared.setUserId("\(userId)", tokenProvider: self) { error in
            #if DEBUG
            if let error {
                print(error)
            } else {
                print("Successfully authenticated with Pusher Beams: \(userId)")
            }
            #endif
        }
    }
    
    func unlink() {
        PushNotifications.shared.clearAllState {
            #if DEBUG
            print("Unlink Pusher Beams")
            #endif
        }
    }
}

//MARK: - Pusher Beam Token Provider
extension AppPushes: TokenProvider {
    func fetchToken(userId: String, completionHandler completion: @escaping (String, Error?) -> Void) throws {
        Task {
            do {
                let token = try await Rest().userPusherAuthToken()
                completion(token, nil)
            } catch {
                completion("", error)
            }
        }
    }
}
