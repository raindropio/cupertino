import SwiftUI
import API
import UI

struct UserLabel<U: UserType>: View {
    var user: U?
    var width: Double
    
    init(_ user: U?, width: Double = 28.0) {
        self.user = user
        self.width = width
    }
    
    var body: some View {
        Label {
            Text(user?.name ?? "Unknown")
        } icon: {
            if let avatar = user?.avatar {
                Thumbnail(avatar, width: width, height: width, cornerRadius: width)
            } else {
                Image(systemName: "person.crop.circle")
                    .symbolRenderingMode(.hierarchical)
            }
        }
    }
}
