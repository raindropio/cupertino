import SwiftUI

public extension ControlGroupStyle where Self == TabsControlGroupStyle {
    static var tabs: Self { .init() }
}

public struct TabsControlGroupStyle: ControlGroupStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.content
                .frame(maxWidth: .infinity)
        }
            .frame(maxWidth: .infinity)
            .labelStyle(_LabelStyle())
    }
}

fileprivate struct _LabelStyle: LabelStyle {
    @Environment(\.verticalSizeClass) private var sizeClass
    
    public func makeBody(configuration: Configuration) -> some View {
        if sizeClass == .regular {
            VStack(spacing: 3) {
                configuration.icon
                    .font(.headline)
                
                configuration.title
                    .font(.footnote)
            }
                .padding(4)
        } else {
            Label(configuration)
                .labelStyle(.titleAndIcon)
        }
    }
}
