import SwiftUI
import API
import Features

struct Receive: View {
    @EnvironmentObject private var service: ExtensionService
    @AppStorage("default-collection") private var defaultCollection: Int?
    
    var decoded: Raindrop? {
        var r: Raindrop? = service.decoded()
        if let defaultCollection {
            r?.collection = defaultCollection
        }
        return r
    }
    
    var body: some View {
        if let decoded {
            RaindropStack(decoded, content: RaindropForm.init)
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
                            .new(link: first, collection: defaultCollection),
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
