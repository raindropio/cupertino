import SwiftUI

public extension FormStyle where Self == FancyFormStyle {
    static var fancy: Self {
        return .init()
    }
}

public struct FancyFormStyle: FormStyle {
    public func makeBody(configuration: Configuration) -> some View {
        Form {
            configuration.content
        }
            #if canImport(AppKit)
            .textFieldStyle(.roundedBorder)
            .controlSize(.large)
            .scenePadding()
            #endif
    }
}
