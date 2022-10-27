import Foundation

public protocol CollectionProtocol: Identifiable, Hashable, Decodable {
    var id: Int { get set }
    var title: String { get }
    var count: Int { get set }
    var systemImage: String { get }
    
    var view: CollectionView { get set }
    var access: CollectionAccess { get }
}
