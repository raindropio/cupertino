import SwiftUI

public extension LabelStyle where Self == TitleAndIconLabelStyle {
    static var searchSuggestion: SearchSuggestionLabelStyle { .init() }
}

public struct SearchSuggestionLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
                .foregroundColor(.primary)
        } icon: {
            configuration.icon
                .symbolVariant(.fill)
                .frame(width: 24, height: 24)
        }
    }
}
