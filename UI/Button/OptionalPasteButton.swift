import SwiftUI
import UniformTypeIdentifiers

public struct OptionalPasteButton: View {
    @State private var reload = UUID()
    
    var supportedContentTypes: [UTType]
    var payloadAction: ([NSItemProvider]) -> Void
    
    public init(supportedContentTypes: [UTType], payloadAction: @escaping ([NSItemProvider]) -> Void) {
        self.supportedContentTypes = supportedContentTypes
        self.payloadAction = payloadAction
    }
    
    private var has: Bool {
        #if canImport(UIKit)
        UIPasteboard.general.contains(pasteboardTypes: supportedContentTypes.map { $0.identifier })
        #else
        true
        #endif
    }
    
    public var body: some View {
        Group {
            if has {
                PasteButton(supportedContentTypes: supportedContentTypes, payloadAction: payloadAction)
            }
        }
            #if canImport(UIKit)
            .onReceive(NotificationCenter.default.publisher(for: UIPasteboard.changedNotification)) { _ in
                reload = .init()
            }
            #endif
    }
}
