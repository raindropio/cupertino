import Foundation

extension Rest {
    public static func raindropCacheLink(_ id: Raindrop.ID) -> URL {
        .init(string: "raindrop/\(id)/cache", relativeTo: base.api)!
    }
}
