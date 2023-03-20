import SwiftUI
import API
import Features

struct Receive: View {
    @EnvironmentObject private var service: ExtensionService
    @AppStorage("extension-default-collection", store: UserDefaults(suiteName: Constants.appGroupName)) private var collection: Int = -1
    
    var decoded: Raindrop? {
        var item: Raindrop? = service.decoded()
        item?.collection = collection
        return item
    }

    var body: some View {
        Group {
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
                                .new(link: first, collection: collection),
                                content: RaindropForm.init
                            )
                        }
                        //files
                        else {
                            SaveFiles(urls: urls)
                        }
                    }
                        .transition(.opacity)
                        .animation(.default, value: loading)
                }
            }
        }
            #if canImport(UIKit)
            .frame(idealWidth: 400, idealHeight: 600)
            #else
            .frame(width: 400).frame(minHeight: 300)
            .fixedSize()
            #endif
    }
}
