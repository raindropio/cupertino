import UniformTypeIdentifiers
import SwiftUI

extension UTType {
    public static var raindrop = UTType(exportedAs: "\(Bundle.main.bundleIdentifier!).raindrop")
}

extension Raindrop: CustomItemProvider {
    public var itemProvider: NSItemProvider {
        let provider = NSItemProvider(object: link as NSURL)
        provider.suggestedName = title
        provider.registerItem(forTypeIdentifier: UTType.raindrop.identifier) { completion, _, _ in
            completion?(NSData(data: "\(id)".data(using: .utf8)!), nil)
        }
        return provider
    }
    
    public static func getData(_ itemProvider: NSItemProvider) async -> Raindrop.ID? {
        let data = (try? await itemProvider.loadItem(forTypeIdentifier: UTType.raindrop.identifier)) as? Data
        guard let data else { return nil }
        let string = String(data: data, encoding: .utf8)
        guard let string else { return nil }
        return Int(string)
    }
    
    public static func getData(_ items: [NSItemProvider]) async -> Set<Raindrop.ID> {
        var ids = Set<Raindrop.ID>()
        for item in items {
            let id = await getData(item)
            if let id {
                ids.insert(id)
            }
        }
        return ids
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Raindrop: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .raindrop)
        ProxyRepresentation(exporting: \.link)
    }
}
