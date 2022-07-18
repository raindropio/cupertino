import SwiftUI

public struct LabelStyleOverride: LabelStyle {
    public var title: String?
    public var systemImage: String?
    
    public func makeBody(configuration: Configuration) -> some View {
        Label {
            if let title {
                Text(title)
            } else {
                configuration.title
            }
        } icon: {
            if let systemImage {
                Image(systemName: systemImage)
            } else {
                configuration.icon
            }
        }
    }
}
