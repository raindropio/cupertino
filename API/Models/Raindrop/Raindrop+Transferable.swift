import UniformTypeIdentifiers
import SwiftUI

extension UTType {
    public static var raindrop = UTType(exportedAs: "\(Bundle.main.bundleIdentifier!).raindrop")
}

extension Raindrop: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .raindrop)
        
        ProxyRepresentation(exporting: \.link)
            .exportingCondition { $0.file == nil }
        
        //partially work on iOS <=17
        //RemoteFileRepresentation(exporting: \.link, mimeType: \.file?.type)
    }
    
    public var sharePreview: SharePreview<Never,Never> {
        .init(title)
    }
}
