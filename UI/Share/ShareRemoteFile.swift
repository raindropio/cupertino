import SwiftUI
import UniformTypeIdentifiers

public struct ShareRemoteFile: View {    
    public var url: URL
    public var fileName: String?
    
    public init(_ url: URL, fileName: String? = nil) {
        self.url = url
        self.fileName = fileName
    }
    
    public var body: some View {
        ActionButton {
            let (temp, res) = try await URLSession.shared.download(from: url)
            
            let renamed = temp
                .deletingLastPathComponent()
                .appendingPathComponent(fileName ?? res.suggestedFilename!)
            
            try? FileManager.default.removeItem(at: renamed)
            try FileManager.default.moveItem(at: temp, to: renamed)
            
            let keyWindow = UIApplication
                .shared
                .connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                .last

            if var topController = keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }

                let picker = UIActivityViewController(activityItems: [renamed], applicationActivities: nil)
                picker.popoverPresentationController?.sourceView = topController.view
                picker.popoverPresentationController?.sourceRect = CGRect(x: topController.view.bounds.midX, y: topController.view.bounds.midY,width: 0,height: 0)
                topController.present(picker, animated: true)
            }
        } label: {
            Label("Share", systemImage: "square.and.arrow.up")
        }
    }
}
