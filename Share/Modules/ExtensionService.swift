import SwiftUI
import UniformTypeIdentifiers

final class ExtensionService: ObservableObject {
    private weak var context: NSExtensionContext?
    
    var preprocessed: NSDictionary?
    var items = [NSItemProvider]()
    
    init(_ context: NSExtensionContext? = nil) {
        self.context = context
        self.load()
    }
    
    func decoded<T: Decodable>() -> T? {
        if let preprocessed {
            let data = try? JSONSerialization.data(withJSONObject: preprocessed)
            if let data {
                return try? JSONDecoder().decode(T.self, from: data)
            }
        }
        return nil
    }
    
    func close() {
        context?.completeRequest(returningItems: context?.inputItems ?? [])
    }
}

extension ExtensionService {
    private func load() {
        guard let context else { return }
        
        for input in context.inputItems {
            guard let input = input as? NSExtensionItem else { continue }
            guard let attachments = input.attachments else { continue }
                        
            for attachment in attachments {
                //preprocessed javascript
                if attachment.hasItemConformingToTypeIdentifier(UTType.propertyList.identifier) {
                    loadPreprocessed(attachment)
                    return
                }
                else {
                    items.append(attachment)
                }
            }
        }
    }
    
    private func loadPreprocessed(_ attachment: NSItemProvider) {
        attachment.loadItem(forTypeIdentifier: UTType.propertyList.identifier) { item, error in
            if let item = item as? NSDictionary,
               let result = item[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary {
                self.preprocessed = result
            }
        }
    }
}
