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
        UIPasteboard.general.contains(pasteboardTypes: supportedContentTypes.map { $0.identifier })
    }
    
    public var body: some View {
        Group {
            if has {
                PasteButton(supportedContentTypes: supportedContentTypes, payloadAction: payloadAction)
            }
        }
            .onReceive(NotificationCenter.default.publisher(for: UIPasteboard.changedNotification)) { _ in
                reload = .init()
            }
    }
}
