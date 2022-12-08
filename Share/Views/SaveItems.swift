import SwiftUI
import API
import Common

struct SaveItems: View {
    @EnvironmentObject private var service: ExtensionService
    
    var body: some View {
        if let raindrop: Raindrop = service.decoded() {
            RaindropStack(raindrop)
        } else {
            AddDetect(service.items) { loading, urls in
                //loading
                if loading {
                    ProgressView().progressViewStyle(.circular)
                        .backport.presentationDetents([.height(200)])
                        .presentationUndimmed(.height(200))
                }
                //web url
                else if let first = urls.first, !first.isFileURL {
                    RaindropStack(first)
                }
                //files
                else {
                    AddStack(urls)
                        .backport.presentationDetents([.height(200)])
                        .presentationUndimmed(.height(200))
                }
            }
        }
    }
}
