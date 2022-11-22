import Foundation

extension Rest {
    struct IdsRequest<ID: Encodable>: Encodable {
        var ids: [ID]
    }
}
