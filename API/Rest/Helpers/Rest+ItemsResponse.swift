extension Rest {
    struct ItemsResponse<Item: Decodable>: Decodable {
        var items: [Item]
        var count: Int? = nil
    }
}
