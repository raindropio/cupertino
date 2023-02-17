import Foundation
import CoreTransferable

extension Array where Element == NSItemProvider {
    //detect URLs of files or web pages (including from text)
    public func urls() async -> Set<URL> {
        var found: Set<URL> = []
        for item in self {
            let url = try? await item.url()
            if let url {
                found.insert(url)
            }
        }
        return found
    }
}

extension NSItemProvider {
    //detect single URL of file or web page (including from text)
    public func url() async throws -> URL? {
        try await self.loadTransferable(type: AnyURL.self).rawValue
    }
}

fileprivate struct AnyURL: Transferable {
    private var string: String { rawValue.absoluteString }
    private var data: Data { rawValue.dataRepresentation }

    let rawValue: URL
    
    @Sendable init(_ url: URL) throws {
        if url.isFileURL {
            //unlock file
            _ = url.startAccessingSecurityScopedResource()
            //always make a file copy, required in any case
            let copy = FileManager.default.temporaryDirectory
                .appendingPathComponent(url.lastPathComponent)
            try? FileManager.default.removeItem(at: copy)
            try FileManager.default.copyItem(at: url, to: copy)
            self.rawValue = copy
        } else {
            self.rawValue = url
        }
    }
    
    @Sendable init(_ received: ReceivedTransferredFile) throws {
        try self.init(received.file)
    }
    
    @Sendable init(_ text: String) throws {
        if let detected: URL = URL.detect(from: text) {
            try self.init(detected)
        } else {
            throw MyError.ignore
        }
    }
    
    //youtube specific
    @Sendable init(_ data: Data) throws {
        let text = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? String
        if let text {
            try self.init(text)
        } else {
            throw MyError.ignore
        }
    }
        
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.rawValue, importing: self.init)
        FileRepresentation(importedContentType: .fileURL, importing: self.init)
        FileRepresentation(importedContentType: .image, importing: self.init)
        FileRepresentation(importedContentType: .video, importing: self.init)
        FileRepresentation(importedContentType: .movie, importing: self.init)
        FileRepresentation(importedContentType: .audio, importing: self.init)
        FileRepresentation(importedContentType: .pdf, importing: self.init)
        ProxyRepresentation(exporting: \.string, importing: self.init)
        DataRepresentation(contentType: .text, exporting: \.data, importing: self.init)
    }
    
    enum MyError: Error {
        case ignore
    }
}
