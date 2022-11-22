public struct UpdateCollectionsRequest: Encodable {
    var expanded: Bool?
    var sort: Sort?
    
    public enum Sort: String, Encodable {
        case titleAsc = "title"
        case titleDesc = "-title"
        case countDesc = "-count"
    }
}
