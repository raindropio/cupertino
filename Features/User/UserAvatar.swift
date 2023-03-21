import SwiftUI
import API
import UI

public struct UserAvatar<U: UserType>: View {
    var user: U?
    var width: Double
    
    public init(_ user: U?, width: Double? = nil) {
        self.user = user
        self.width = width ?? 28.0
    }
    
    public var body: some View {
        if let avatar = user?.avatar {
            Thumbnail(avatar, width: width, height: width)
                .cornerRadius(width)
        } else {
            Image(systemName: "person.crop.circle")
                .symbolVariant(.fill)
        }
    }
}
