extension Rest {
    struct ItemResponse<Item: Decodable>: Decodable {
        var item: Item
    }
}
