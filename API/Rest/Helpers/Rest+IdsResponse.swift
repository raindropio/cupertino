import Foundation

extension Rest {
    struct IdsResponse<ID: Decodable>: Decodable {
        var ids: [ID]
    }
}
