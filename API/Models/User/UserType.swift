import Foundation

public protocol UserType: Identifiable {
    var id: Int { get }
    var name: String { get set }
    var avatar: URL? { get set }
    var email: String { get set }
}
