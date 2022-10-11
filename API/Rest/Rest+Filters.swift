import Foundation

extension Rest {
    struct Filters {}
}

//MARK: - Get
extension Rest.Filters {
    static func get(_ find: FindBy) async throws -> [Filter] {
        []
    }
}
