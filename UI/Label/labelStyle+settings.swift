import SwiftUI

public extension LabelStyle where Self == TitleAndIconLabelStyle {
    static var settings: SettingsLabelStyle { SettingsLabelStyle() }
}

public struct SettingsLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
        } icon: {
            ZStack {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(.tint)
                    .frame(width: 28, height: 28)
                
                configuration.icon
                    .foregroundColor(.white)
                    .symbolRenderingMode(.monochrome)
                    .symbolVariant(.fill)
                    .imageScale(.medium)
            }
        }
    }
}
