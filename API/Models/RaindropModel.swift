public struct Raindrop: Identifiable, Hashable {
    public var id: Int
    public var title: String
}

//MARK: Preview
public extension Raindrop {
    static var preview = [
        Raindrop(id: 272043111, title: "Челленджи в TMNT: Shredder’s Revenge"),
        Raindrop(id: 376070368, title: "IQUNIX ZX-1 Aluminum Mini-ITX Case")
    ]
}
