import UniformTypeIdentifiers
import SwiftUI

struct RemoteFileRepresentation<I: Transferable>: TransferRepresentation {
    typealias Item = I
    var exporting: @Sendable (I) throws -> URL
    var mimeType: @Sendable (I) -> String?
    
    @Sendable
    private func getFileUrl(_ item: I) async throws -> SentTransferredFile {
        let (temp, res) = try await URLSession.shared.download(from: exporting(item))
        
        let renamed = temp
            .deletingLastPathComponent()
            .appendingPathComponent(res.suggestedFilename!)
        
        try? FileManager.default.removeItem(at: renamed)
        try FileManager.default.moveItem(at: temp, to: renamed)
                
        return .init(renamed)
    }
    
    var body: some TransferRepresentation {
        //content type adapted
        FileRepresentation(exportedContentType: .image, exporting: getFileUrl)
            .exportingCondition { UTType(mimeType: mimeType($0) ?? "")?.conforms(to: .image) == true }

        FileRepresentation(exportedContentType: .audio, exporting: getFileUrl)
            .exportingCondition { UTType(mimeType: mimeType($0) ?? "")?.conforms(to: .audio) == true }

        FileRepresentation(exportedContentType: .movie, exporting: getFileUrl)
            .exportingCondition { UTType(mimeType: mimeType($0) ?? "")?.conforms(to: .movie) == true }

        FileRepresentation(exportedContentType: .pdf, exporting: getFileUrl)
            .exportingCondition { UTType(mimeType: mimeType($0) ?? "")?.conforms(to: .pdf) == true }
        
        FileRepresentation(exportedContentType: .epub, exporting: getFileUrl)
            .exportingCondition { UTType(mimeType: mimeType($0) ?? "")?.conforms(to: .epub) == true }
        
        //universal
        FileRepresentation(exportedContentType: .content, exporting: getFileUrl)
            .exportingCondition { UTType(mimeType: mimeType($0) ?? "")?.conforms(to: .content) == true }
        
        FileRepresentation(exportedContentType: .fileURL, exporting: getFileUrl)
            .exportingCondition { UTType(mimeType: mimeType($0) ?? "")?.conforms(to: .fileURL) == true }
    }
}
