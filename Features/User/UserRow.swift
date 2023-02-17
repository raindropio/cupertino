import SwiftUI
import API
import UI

struct UserRow<U: UserType>: View {
    var user: U?
    var width: Double?
    
    init(_ user: U?, width: Double? = nil) {
        self.user = user
        self.width = width
    }
    
    var body: some View {
        Label {
            Text(user?.name ?? "Unknown")
        } icon: {
            UserAvatar(user, width: width)
        }
    }
}
