import SwiftUI
import API
import Common

struct SaveItems: View {
    @EnvironmentObject private var service: ExtensionService
    
    var body: some View {
        if service.loading {
            ProgressView().progressViewStyle(.circular)
                .backport.presentationDetents([.height(100)])
                .presentationUndimmed(.height(100))
        } else if let raindrop: Raindrop = service.decoded() {
            RaindropStack(raindrop)
        } else if let webURL = service.webURL() {
            RaindropStack(webURL)
        } else if let files = service.filesURL() {
            UploadFilesStack(files)
        }
    }
}
