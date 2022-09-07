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
            .init(
                id: 33,
                title: "Development",
                cover: URL(string: "https://up.raindrop.io/collection/thumbs/836/440/3/c126f0e4e5839b60acf123515f398263.png"),
                sort: 0,
                count: 943
            ),
            .init(
                id: 134,
                title: "Inspiration",
                cover: URL(string: "https://up.raindrop.io/collection/thumbs/275/2/4deca09fcc940c6aabf3cf08a96f6665.png"),
                parentId: 66,
                sort: 0,
                count: 44
            ),
            .init(
                id: 234,
                title: "Fonts",
                cover: URL(string: "https://up.raindrop.io/collection/thumbs/836/440/3/c126f0e4e5839b60acf123515f398263.png"),
                parentId: 66,
                sort: 1,
                count: 12
            ),
            .init(
                id: 355,
                title: "Utils & Kits",
                cover: URL(string: "https://up.raindrop.io/collection/thumbs/340/438/9/c524e8435d45cf0998d076bb26a4748f.png"),
                parentId: 134,
                sort: 0,
                count: 3
            ),
            .init(
                id: 356,
                title: "Websites",
                cover: URL(string: "https://up.raindrop.io/collection/thumbs/837/952/4/49b5fe6b61e380418a9258bbef0af300.png"),
                parentId: 134,
                sort: 1,
                count: 8
            ),
        ]
    }
}
