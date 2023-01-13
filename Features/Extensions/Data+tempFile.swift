import Foundation

extension Data {
    public func tempFile(_ name: String?, ext: String) -> URL? {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(name ?? UUID().uuidString)
            .appendingPathExtension(ext)
        
        if (try? write(to: url)) != nil {
            return url
        }
        return nil
    }
}
