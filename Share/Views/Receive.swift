import SwiftUI
import API
import Common
import Backport

struct Receive: View {
    @EnvironmentObject private var service: ExtensionService
    
    var body: some View {
        if let raindrop: Raindrop = service.decoded() {
            RaindropStack(raindrop)
        } else {
            AddDetect(service.items) { loading, urls in
                Group {
                    //loading
                    if loading {
                        ProgressView()
                            .backport.presentationDetents([.medium])
                    }
                    //nothing found
                    else if urls.isEmpty {
                        NothingFound()
                    }
                    //web url
                    else if let first = urls.first, !first.isFileURL {
                        RaindropStack(first)
                    }
                    //files
                    else {
                        SaveFiles(urls: urls)
                    }
                }
                    .presentationUndimmed(.medium)
                    .transition(.opacity)
                    .animation(.default, value: loading)
            }
        }
    }
}
