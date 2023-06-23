import UniformTypeIdentifiers
import SwiftUI

extension UTType {
    public static var raindrop = UTType(exportedAs: "\(Bundle.main.bundleIdentifier!).raindrop")
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Raindrop: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .raindrop)
        
        ProxyRepresentation{ raindrop -> URL in
            if raindrop.file != nil {
                let (url, _) = try await URLSession.shared.download(from: raindrop.link, actualFileName: true)
                return url
            }
            return raindrop.link
        } backport: { raindrop in
            raindrop.link
        }
    }
    
    public var sharePreview: SharePreview<Never,Never> {
        .init(title)
    }
}

