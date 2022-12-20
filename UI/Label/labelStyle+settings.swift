import SwiftUI
import Backport

public extension LabelStyle where Self == TitleAndIconLabelStyle {
    static var settings: SettingsLabelStyle { SettingsLabelStyle() }
}

public struct SettingsLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
        } icon: {
            ZStack {
                Image(systemName: "square")
                    .font(.system(size: 32))
                    .symbolVariant(.fill)

                configuration.icon
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .backport.fontWeight(.semibold)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
        }
    }
}
