import SwiftUI

public func CopyButton(items: [URL]) -> some View {
    Button {
        #if canImport(UIKit)
        UIPasteboard.general.urls = items
        #else
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(items.map { $0.absoluteString }.joined(separator: "\n"), forType: .string)
        #endif
    } label: {
        Label("Copy", systemImage: "link")
    }
}
