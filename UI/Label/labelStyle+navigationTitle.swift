import SwiftUI

public extension LabelStyle where Self == TitleAndIconLabelStyle {
    static var navigationTitle: NavigationTitleLabelStyle { NavigationTitleLabelStyle() }
}

public struct NavigationTitleLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
                .font(.headline)
                .lineLimit(1)
        } icon: {
            configuration.icon
                .frame(width: 28, height: 28)
        }
            .labelStyle(.titleAndIcon)
    }
}
