import Foundation

protocol CustomItemProvider {
    associatedtype ItemProviderType
    var itemProvider: NSItemProvider { get }
    static func getData(_ itemProvider: NSItemProvider) async -> ItemProviderType?
}
