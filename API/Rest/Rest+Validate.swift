import Foundation

extension Rest {
    func validate(data: Data, res: URLResponse) async throws {
        //validate only json
        guard let mimeType = res.mimeType, mimeType.contains("json")
        else { return }
        
        let failed: FailedResponse = try await fetch.decode(data: data)
        
        switch failed.status {
        case 400: throw RestError.invalid(failed.errorMessage)
        case 401: throw RestError.unauthorized
        case 403: throw RestError.forbidden
        case 404: throw RestError.notFound
        default: break
        }
    }
    
    fileprivate struct FailedResponse: Decodable {
        var status: Int?
        var errorMessage: String?
    }
}
