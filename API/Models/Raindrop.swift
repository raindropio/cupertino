import Foundation
import UniformTypeIdentifiers
import SwiftUI

public struct Raindrop: Identifiable, Hashable, Codable {
    public var id: Int
    public var link: URL
    public var title: String
    public var excerpt: String = ""
    public var cover: Cover?
    public var created: Date = Date()
    public var type: `Type` = .link
    
    public var favicon: URL? {
        if let host = link.host() {
            return Render.asFaviconUrl(host, options: .width(48), .height(48))
        } else {
            return nil
        }
    }
}

extension UTType {
    public static var raindrop = UTType(exportedAs: "\(Bundle.main.bundleIdentifier!).raindrop")
}

extension Raindrop: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .raindrop)
        DataRepresentation(exportedContentType: .url) {
            $0.link.dataRepresentation
        }
        ProxyRepresentation(exporting: \.title)
    }
}
