import SwiftUI

public struct PreviewData {
    public struct Collections {
        static public var system = [
            Collection(id: 0, title: "All bookmarks"),
            Collection(id: -1, title: "Unsorted"),
        ]
        static public var items: [Collection] = [
            .init(
                id: 66,
                title: "Design",
                count: 1043,
                cover: URL(string: "https://up.raindrop.io/collection/thumbs/468/8/e0778971d0c6c783f7119f5d75219c33.png"),
                expanded: true,
                sort: 1
            ),
            .init(
                id: 8364403,
                title: "Development",
                count: 943,
                cover: URL(string: "https://up.raindrop.io/collection/thumbs/836/440/3/c126f0e4e5839b60acf123515f398263.png"),
                sort: 0
            ),
            .init(
                id: 2752,
                title: "Inspiration",
                count: 44,
                cover: URL(string: "https://up.raindrop.io/collection/thumbs/275/2/4deca09fcc940c6aabf3cf08a96f6665.png"),
                parent: 66,
                sort: 0
            ),
            .init(
                id: 890646,
                title: "Fonts",
                count: 12,
                cover: URL(string: "https://up.raindrop.io/collection/thumbs/836/440/3/c126f0e4e5839b60acf123515f398263.png"),
                parent: 66,
                sort: 1
            ),
            .init(
                id: 3404389,
                title: "Utils & Kits",
                count: 3,
                cover: URL(string: "https://up.raindrop.io/collection/thumbs/340/438/9/c524e8435d45cf0998d076bb26a4748f.png"),
                parent: 66,
                sort: 0
            ),
            .init(
                id: 8379524,
                title: "Websites",
                count: 8,
                cover: URL(string: "https://up.raindrop.io/collection/thumbs/837/952/4/49b5fe6b61e380418a9258bbef0af300.png"),
                parent: 2752,
                sort: 1
            ),
            .init(
                id: 8379661,
                title: "Frontend",
                parent: 8364403
            )
        ]
    }
}

