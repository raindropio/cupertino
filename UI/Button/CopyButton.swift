import SwiftUI

public func CopyButton(items: [URL]) -> some View {
    Button {
        UIPasteboard.general.urls = items
    } label: {
        Label("Copy", systemImage: "doc.on.doc")
    }
}
