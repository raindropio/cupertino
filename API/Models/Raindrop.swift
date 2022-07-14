import Foundation

public struct Raindrop: Identifiable, Hashable {
    public var id: Int
    public var link: URL
    public var title: String
}

//MARK: - Preview
public extension Raindrop {
    static var preview = [
        Raindrop(id: 272043111, link: URL(string: "https://sarunw.com/posts/swiftui-menu-bar-app/")!, title: "Челленджи в TMNT: Shredder’s Revenge"),
        Raindrop(id: 376070368, link: URL(string: "https://swiftwithmajid.com/2020/09/02/displaying-recursive-data-using-outlinegroup-in-swiftui/")!, title: "IQUNIX ZX-1 Aluminum Mini-ITX Case")
    ]
}
