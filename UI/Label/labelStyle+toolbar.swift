import SwiftUI

public struct ToolbarLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 26, *) {
            Label(configuration)
        } else {
            Label(configuration)
                .labelStyle(.titleOnly)
        }
    }
}

@available(iOS, introduced: 16.4, obsoleted: 26, message: "Remove this property in iOS 26")
public extension LabelStyle where Self == ToolbarLabelStyle {
    static var toolbar: Self { .init() }
}
