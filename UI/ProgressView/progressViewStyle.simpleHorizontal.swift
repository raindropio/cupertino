import SwiftUI

public extension ProgressViewStyle where Self == DefaultProgressViewStyle {
    static var simpleHorizontal: ProgressViewSimpleHorizontalStyle { ProgressViewSimpleHorizontalStyle() }
}

public struct ProgressViewSimpleHorizontalStyle: ProgressViewStyle {
    public func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        GeometryReader { geo in
            Rectangle()
                .foregroundColor(.accentColor)
                .frame(width: geo.size.width * fractionCompleted, height: 3)
                .animation(.easeInOut(duration: 0.5), value: fractionCompleted)
        }
    }
}
