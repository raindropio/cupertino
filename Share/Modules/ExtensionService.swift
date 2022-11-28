import SwiftUI
import UniformTypeIdentifiers

final class ExtensionService: ObservableObject {
    @Published var loading = false
    @Published var preprocessed: NSDictionary?
    @Published var items = Set<URL>()
    
    private weak var context: NSExtensionContext?
    
    init(_ context: NSExtensionContext? = nil) {
        self.context = context
        Task.detached(priority: .background, operation: load)
    }
    
    func close() {
        context?.completeRequest(returningItems: context?.inputItems ?? [])
    }
}

extension ExtensionService {
    @Sendable
    private func load() async {
        await MainActor.run {
            preprocessed = nil
            items = .init()
            loading = true
        }
        
        await parseAttachments()
        
        await MainActor.run {
            //prefer web urls
            let webUrls = items.filter { $0.scheme?.hasPrefix("http") == true }
            if !webUrls.isEmpty {
                items = webUrls
            }
            
            loading = false
        }
    }
    
    @Sendable
    private func parseAttachments() async {
        guard let context else { return }
        
        for input in context.inputItems {
            guard let input = input as? NSExtensionItem else { continue }
            guard let attachments = input.attachments else { continue }
                        
            for attachment in attachments {
                //preprocessed javascript
                if let item: NSDictionary = await attachment.getItem(UTType.propertyList.identifier),
                    let result = item[NSExtensionJavaScriptPreprocessingResultsKey] {
                    _ = await MainActor.run {
                        preprocessed = result as? NSDictionary
                    }
                    return
                }
                //web url
                else if let item: URL = await attachment.getItem(UTType.url.identifier) {
                    _ = await MainActor.run {
                        items.insert(item)
                    }
                    return
                }
                //text
                else if let item: String = await attachment.getItem(UTType.text.identifier),
                    !URL.detect(from: item).isEmpty {
                    _ = await MainActor.run {
                        URL.detect(from: item).forEach { items.insert($0) }
                    }
                    return
                }
                //file url
                else if let item: URL = await attachment.getItem(UTType.fileURL.identifier, UTType.image.identifier, UTType.video.identifier, UTType.movie.identifier, UTType.audio.identifier, UTType.pdf.identifier) {
                    _ = await MainActor.run {
                        items.insert(item)
                    }
                    return
                }
                //image data (usually screenshot)
                else if let item: UIImage = await attachment.getItem(UTType.image.identifier) {
                    let url = FileManager.default.temporaryDirectory
                        .appendingPathComponent(attachment.suggestedName ?? UUID().uuidString)
                        .appendingPathExtension("png")
                    if (try? item.pngData()?.write(to: url)) != nil {
                        _ = await MainActor.run {
                            items.insert(url)
                        }
                    }
                }
                //pdf data (usually screenshot)
                else if let item: Data = await attachment.getItem(UTType.pdf.identifier) {
                    let url = FileManager.default.temporaryDirectory
                        .appendingPathComponent(attachment.suggestedName ?? UUID().uuidString)
                        .appendingPathExtension("pdf")
                    if (try? item.write(to: url)) != nil {
                        _ = await MainActor.run {
                            items.insert(url)
                        }
                    }
                }
            }
        }
    }
}

fileprivate extension NSItemProvider {
    func getItem<T>(_ typeIdentifier: String...) async -> T? {
        for id in typeIdentifier {
            if hasItemConformingToTypeIdentifier(id) {
                let item = (try? await loadItem(forTypeIdentifier: id)) as? T
                return item
            }
        }
        return nil
    }
}
