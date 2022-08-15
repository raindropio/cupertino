import SwiftUI

public struct NavigationTitleLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
                .font(.headline)
        } icon: {
            configuration.icon
                .frame(width: 24, height: 24)
        }
            .labelStyle(.titleAndIcon)
    }
}

public extension LabelStyle where Self == TitleAndIconLabelStyle {
    static var navigationTitle: NavigationTitleLabelStyle { NavigationTitleLabelStyle() }
}
