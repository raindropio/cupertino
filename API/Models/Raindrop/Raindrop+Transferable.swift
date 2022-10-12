import UniformTypeIdentifiers
import SwiftUI

extension UTType {
    public static var raindrop = UTType(exportedAs: "\(Bundle.main.bundleIdentifier!).raindrop")
}

extension Raindrop: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .raindrop)
        DataRepresentation(exportedContentType: .url) {
            $0.link.dataRepresentation
        }
        ProxyRepresentation(exporting: \.title)
    }
}
