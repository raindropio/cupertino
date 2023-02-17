import UniformTypeIdentifiers
import SwiftUI

extension UTType {
    public static var userCollection = UTType(exportedAs: "\(Bundle.main.bundleIdentifier!).collection")
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension UserCollection: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .userCollection)
        ProxyRepresentation(exporting: \.publicPage)
    }
}
