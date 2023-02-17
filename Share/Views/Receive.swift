import SwiftUI
import API
import Features

struct Receive: View {
    @EnvironmentObject private var service: ExtensionService
    
    var body: some View {
        if let item: Raindrop = service.decoded() {
            RaindropStack(item, content: RaindropForm.init)
        } else {
            AddDetect(service.items) { loading, urls in
                Group {
                    //loading
                    if loading {
                        ProgressView()
                            .presentationDetents([.medium])
                    }
                    //nothing found
                    else if urls.isEmpty {
                        NothingFound()
                    }
                    //web url
                    else if let first = urls.first, !first.isFileURL {
                        RaindropStack(
                            .new(link: first),
                            content: RaindropForm.init
                        )
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
