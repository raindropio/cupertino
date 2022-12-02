import SwiftUI

@available(iOS 16.0, *)
public extension LabeledContentStyle where Self == AutomaticLabeledContentStyle {
    static var fix: LabeledContentStyleFix { LabeledContentStyleFix() }
}

@available(iOS 16.0, *)
public struct LabeledContentStyleFix: LabeledContentStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            configuration.content
                .alignmentGuide(.controlAlignment) { $0[.leading] }
        }
            .alignmentGuide(.leading) { $0[.controlAlignment] }
    }
}

@available(iOS 16.0, *)
extension HorizontalAlignment {
    private enum ControlAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.center]
        }
    }
    internal static let controlAlignment = HorizontalAlignment(ControlAlignment.self)
}
