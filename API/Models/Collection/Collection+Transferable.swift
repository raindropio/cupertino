import UniformTypeIdentifiers
import SwiftUI

extension UTType {
    public static var collection = UTType(exportedAs: "\(Bundle.main.bundleIdentifier!).collection")
}

extension Collection: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .collection)
        DataRepresentation(exportedContentType: .url) { _ in
            URL(string: "https://raindrop.io")!.dataRepresentation
        }
        ProxyRepresentation(exporting: \.title)
    }
}
