import Foundation

extension ConfigRaindrops: Codable {
    enum CodingKeys: CodingKey {
        case raindrops_hide
        case raindrops_grid_cover_size
        case raindrops_list_cover_right
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let rawHide = (try? container.decode([String].self, forKey: .raindrops_hide)) ?? []
        hide.keys.forEach { view in
            hide[view]? = .init(Element.allCases.filter {
                rawHide.contains("\(view)_\($0)")
            })
        }
        
        coverSize = (try? container.decode(Int.self, forKey: .raindrops_grid_cover_size)) ?? 2
        coverRight = (try? container.decode(Bool.self, forKey: .raindrops_list_cover_right)) ?? false
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(
            hide.flatMap { (view, element) in
                element.map { "\(view)_\($0)" }
            },
            forKey: .raindrops_hide
        )
        try? container.encode(coverSize, forKey: .raindrops_grid_cover_size)
        try? container.encode(coverRight, forKey: .raindrops_list_cover_right)
    }
}
