import Foundation

extension Client {
    struct Filters {}
}

//MARK: - Get
extension Client.Filters {
    static func get(_ find: FindBy) async throws -> [Filter] {
        []
    }
}
