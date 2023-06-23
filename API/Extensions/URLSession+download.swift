import Foundation

extension URLSession {
    /// Download file to temp folder with actual file name and extension
    func download(from url: URL, actualFileName: Bool) async throws -> (URL, URLResponse) {
        let (temp, res) = try await URLSession.shared.download(from: url)
        if !actualFileName {
            return (temp, res)
        }
        
        let renamed = temp
            .deletingLastPathComponent()
            .appendingPathComponent(res.suggestedFilename!)
        
        try? FileManager.default.removeItem(at: renamed)
        try FileManager.default.moveItem(at: temp, to: renamed)
        
        return (renamed, res)
    }
}
