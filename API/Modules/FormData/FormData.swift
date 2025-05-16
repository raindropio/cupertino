import Foundation
import UniformTypeIdentifiers

struct FormData {
    private var params = [String: Any]()
    
    mutating func append<S: CustomStringConvertible>(key: String, value: S) {
        params[key] = value
    }
    
    mutating func append(key: String, value: URL) {
        params[key] = value
    }
}

extension FormData {
    func buildStream(boundary: String) throws -> (InputStream, UInt64) {
        let lineBreak = "\r\n"

        var length: UInt64 = 0
        var pieces: [InputStream] = []

        func addPiece(_ string: String) {
            let data = Data(string.utf8)
            length += UInt64(data.count)
            pieces.append(InputStream(data: data))
        }

        for (key, value) in params {
            if let url = value as? URL {
                // Header
                let fileName   = url.lastPathComponent
                let mimeType   = UTType(filenameExtension: url.pathExtension)?.preferredMIMEType
                                 ?? "application/octet-stream"

                addPiece("--\(boundary)\(lineBreak)")
                addPiece("""
                         Content-Disposition: form-data; name="\(key)"; filename="\(fileName)"\(lineBreak)\
                         Content-Type: \(mimeType)\(lineBreak)\(lineBreak)
                         """)

                // File body (streaming)
                guard let fileStream = InputStream(url: url) else {
                    throw URLError(.fileDoesNotExist)
                }
                let size = try FileManager.default.attributesOfItem(atPath: url.path)[.size] as? NSNumber
                length += size?.uint64Value ?? 0
                pieces.append(fileStream)

                // Trailing CRLF
                addPiece(lineBreak)
            } else {
                // Simple field
                addPiece("--\(boundary)\(lineBreak)")
                addPiece("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak)\(lineBreak)")
                addPiece("\(value)\(lineBreak)")
            }
        }

        addPiece("--\(boundary)--\(lineBreak)")

        return (MultipartBodyStream(pieces), length)
    }
}

fileprivate extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
