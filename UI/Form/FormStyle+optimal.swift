import SwiftUI

public extension FormStyle where Self == ModernFormStyle {
    static var modern: Self {
        return .init()
    }
}

public struct ModernFormStyle: FormStyle {
    public func makeBody(configuration: Configuration) -> some View {
        Form {
            configuration.content
        }
            #if canImport(AppKit)
            .formStyle(.grouped)
            .labeledContentStyle(ModernFormLabeledContentStyle())
            #endif
    }
}

fileprivate struct ModernFormLabeledContentStyle: LabeledContentStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            configuration.content
        }
    }
}
