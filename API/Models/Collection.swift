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

//MARK: Preview
public extension Collection {
    struct Preview {
        static public var system = [
            Collection(id: 0, title: "All bookmarks"),
            Collection(id: -1, title: "Unsorted"),
        ]
        static public var items: [Collection] = [
            .init(
                id: 66,
                title: "Design",
                cover: URL(string: "https://up.raindrop.io/collection/thumbs/468/8/e0778971d0c6c783f7119f5d75219c33.png"),
                expanded: true,
                sort: 1,
                count: 1043
            ),
            .init(id: 33, title: "Development", sort: 0, count: 943),
            .init(id: 134, title: "Inspiration", parentId: 66, sort: 0, count: 44),
            .init(id: 234, title: "Fonts", parentId: 66, sort: 1, count: 12),
            .init(id: 355, title: "UIUX", parentId: 134, sort: 0, count: 3),
            .init(id: 356, title: "Websites", parentId: 134, sort: 1, count: 8),
        ]
    }
}
