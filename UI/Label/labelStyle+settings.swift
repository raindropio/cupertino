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
            configuration.icon
                .symbolVariant(.fill)
                .imageScale(.large)
        }
    }
}
