import Foundation

protocol FetchDelegate: AnyObject {
    var decoder: JSONDecoder { get }
    var encoder: JSONEncoder { get }
    
    func validate(data: Data, res: URLResponse) async throws
}

extension FetchDelegate {
    func validate(data: Data, res: URLResponse) async throws {}
}
