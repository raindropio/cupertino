import SwiftUI

public extension LabelStyle where Self == TitleAndIconLabelStyle {
    static var sidebar: SidebarLabelStyle { SidebarLabelStyle() }
}

public struct SidebarLabelStyle: LabelStyle {    
    public func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
        } icon: {
            configuration.icon
                .symbolVariant(.fill)
                #if canImport(UIKit)
                .imageScale(.large)
                #endif
        }
    }
}
