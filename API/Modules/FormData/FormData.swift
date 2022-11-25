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
    func encode(_ boundary: String) throws -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        
        for (key, value) in params {
            //File url
            if let url = value as? URL {
                let fileName = url.lastPathComponent
                let mimeType = UTType(filenameExtension: url.pathExtension)?.preferredMIMEType ?? "application/octet-stream"
                
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\(lineBreak)")
                body.append("Content-Type: \(mimeType + lineBreak + lineBreak)")
                body.append(try Data(contentsOf: url))
                body.append(lineBreak)
            }
            //Any string'able
            else if let string = value as? CustomStringConvertible {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak)\(lineBreak)")
                body.append("\(string)\(lineBreak)")
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
}

fileprivate extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
