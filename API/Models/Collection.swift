import Foundation
import UniformTypeIdentifiers
import SwiftUI

public struct Collection: Identifiable, Hashable, Codable {
    public var id: Int
    public var title: String
    public var cover: URL?
    public var parentId: Collection.ID?
    public var expanded: Bool = false
    public var sort = 0
    public var count = 0
//    public var color: Color?
    public var view: View = .list
    
    public var systemImage: String {
        "folder"
    }
    public var isSystem: Bool { id <= 0 }
}

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
