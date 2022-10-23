import Foundation

extension FiltersState {
    public struct Group: Equatable, Codable {
        var raindrops = 0
        var general = [Filter]()
        var tags = [Filter]()
        var created = [Filter]()
    }
    
    //access specific group by state[find]
    subscript(find: FindBy) -> Group {
        get { groups[find] ?? .init() }
        set {
            groups[find] = newValue
        }
    }
}
