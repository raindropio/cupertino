import SwiftUI

public extension PrimitiveButtonStyle where Self == SubmitButtonStyle {
    static var submit: Self {
        return .init()
    }
}

public struct SubmitButtonStyle: PrimitiveButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        Button(action: configuration.trigger, label: {
            configuration.label
                .frame(maxWidth: .infinity)
        })
            .buttonStyle(.borderedProminent)
            .fontWeight(.medium)
            .clearSection()
    }
}
