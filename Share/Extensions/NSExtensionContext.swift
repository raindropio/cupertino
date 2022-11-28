import Foundation
import UniformTypeIdentifiers

extension NSExtensionContext {
    var contentText: String {
        for input in inputItems {
            guard let input = input as? NSExtensionItem else { continue }
            guard let text = input.attributedContentText?.string else { continue }
            return text
        }
        return ""
    }
    
    var allAttachments: [NSItemProvider] {
        var found = [NSItemProvider]()
        
        for input in inputItems {
            guard let input = input as? NSExtensionItem else { continue }
            if let attachments = input.attachments {
                found += attachments
            }
        }
        
        return found
    }
    
    func allItems() async -> [NSSecureCoding] {
        var items = [NSSecureCoding]()
        let attachments = allAttachments
        
        for attachment in attachments {
            for id in attachment.registeredTypeIdentifiers {
                let item = try? await attachment.loadItem(forTypeIdentifier: id)
                if let item {
                    items.append(item)
                }
            }
        }
        
        return items
    }
    
    func decodeJavaScriptProcessing<T: Decodable>() async throws -> T? {
        let attachment = allAttachments.first {
            $0.hasItemConformingToTypeIdentifier(UTType.propertyList.identifier)
        }
        guard let attachment else { return nil }
        
        let item = try await attachment.loadItem(forTypeIdentifier: UTType.propertyList.identifier)
        let dict = (item as? NSDictionary)?[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary
                
        if let dict {
            let data = try? JSONSerialization.data(withJSONObject: dict)
            if let data {
                return try? JSONDecoder().decode(T.self, from: data)
            }
        }
        
        return nil
    }
}
