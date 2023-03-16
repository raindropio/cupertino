import SwiftUI
import UniformTypeIdentifiers

final class ExtensionService: ObservableObject {
    private weak var context: NSExtensionContext?
    
    let extensionType: ExtensionType = .detect()
    @Published var loaded = false
    @Published var preprocessed: NSDictionary?
    @Published var items = [NSItemProvider]()
    
    init(_ context: NSExtensionContext? = nil) {
        self.context = context
                    
        Task {
            await load()
            loaded = true
        }
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
    
    var containsText: Bool {
        items.contains {
            $0.hasItemConformingToTypeIdentifier(UTType.text.identifier)
        }
    }
}

enum ExtensionType {
    case share
    case action
    
    static func detect() -> Self {
        let id = (Bundle.main.infoDictionary?["NSExtension"] as? [String: Any])?["NSExtensionPointIdentifier"] as? String
        return id == "com.apple.ui-services" ? .action : .share
    }
}

extension ExtensionService {
    @MainActor
    private func load() async {
        guard let context else { return }
        
        for input in context.inputItems {
            guard let input = input as? NSExtensionItem else { continue }
            guard let attachments = input.attachments else { continue }
                        
            for attachment in attachments {
                //preprocessed javascript
                if attachment.hasItemConformingToTypeIdentifier(UTType.propertyList.identifier) {
                    await loadPreprocessed(attachment)
                    return
                }
                else {
                    items.append(attachment)
                }
            }
        }
    }
    
    @MainActor
    private func loadPreprocessed(_ attachment: NSItemProvider) async {
        let item = try? await attachment.loadItem(forTypeIdentifier: UTType.propertyList.identifier)
        if let item = item as? NSDictionary,
           let result = item[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary {
            self.preprocessed = result
        }
    }
}
