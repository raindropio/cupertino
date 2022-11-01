import Foundation

//MARK: - Get
extension Rest {
    public func iconsGet(_ filter: String = "") async throws -> [URL] {
        let res: ItemsResponse<Theme> = try await fetch.get("collections/covers/\(filter)")
        var icons = [URL]()
        
        res.items.forEach { theme in
            icons = icons + theme.icons
                .compactMap { $0.png }
        }
        
        return icons.unique()
    }
    
    fileprivate struct Theme: Decodable {
        var icons: [Icon]
        
        struct Icon: Decodable {
            var png: URL?
        }
    }
}
