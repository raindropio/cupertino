import SwiftUI

public extension PrimitiveButtonStyle where Self == HighPriorityButtonStyle {
    static var highPriority: Self {
        return .init()
    }
}

public struct HighPriorityButtonStyle: PrimitiveButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        Button(configuration)
            .onTapGesture(perform: configuration.trigger)
    }
}
