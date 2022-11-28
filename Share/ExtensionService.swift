import SwiftUI
import UniformTypeIdentifiers
import API

class ExtensionService: ObservableObject {
    @Published var raindrop: Raindrop?
    @Published var files = Set<URL>()
    
    weak var context: NSExtensionContext?
    
    init(_ context: NSExtensionContext?) {
        self.context = context
        
        Task.detached(priority: .background) {
            await self.detectRaindrop()
            
            if self.raindrop == nil {
                await self.detectOther()
            }
        }
    }
    
    func detectRaindrop() async {
        let raindrop: Raindrop? = try? await context?.decodeJavaScriptProcessing()
        await MainActor.run { [raindrop] in
            self.raindrop = raindrop
        }
    }
    
    func detectOther() async {
        guard let context else { return }
        
        let items = await context.allItems()
        
        //generate new raindrop by link
        var raindrop: Raindrop? = items
            .flatMap {
                switch $0 {
                case let url as URL:
                    return [url]
                    
                case let string as String:
                    let urls: [URL] = URL.detect(from: string)
                    return urls
                    
                default: return []
                }
            }
            .filter {
                $0 != nil && $0?.scheme != "file"
            }
            .map {
                Raindrop.new(link: $0)
            }
            .first
        
        //set title from content text
        raindrop?.title = context.contentText
        
        //find file urls
        let files = items
            .compactMap {
                switch $0 {
                case let url as URL:
                    return url
                    
                case let image as UIImage:
                    let url = FileManager.default.temporaryDirectory
                        .appendingPathComponent(UUID().uuidString)
                        .appendingPathExtension("png")
                    try? image.pngData()?.write(to: url)
                    return url
                    
                default:
                    return nil
                }
            }
            .filter {
                $0.scheme == "file"
            }
        
        //set
        await MainActor.run { [raindrop, files] in
            self.raindrop = raindrop
            self.files = Set(files)
        }
    }
}
