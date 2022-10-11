import Foundation

extension Client {
    struct Recent {}
}

//MARK: - Search
extension Client.Recent {
    static func search() async throws -> [String] {
        []
    }
}

//MARK: - Tags
extension Client.Recent {
    static func tags() async throws -> [String] {
        []
    }
}
