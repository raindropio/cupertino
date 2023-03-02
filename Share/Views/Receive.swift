import SwiftUI
import API
import Features

struct Receive: View {
    @EnvironmentObject private var service: ExtensionService
    
    var body: some View {
        switch service.extensionType {
        case .share:
            Share()
            
        case .action:
            Action()
        }
    }
}

extension Receive {
    struct Share: View {
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
                        .transition(.opacity)
                        .animation(.default, value: loading)
                }
            }
        }
    }
}

extension Receive {
    struct Action: View {
        @EnvironmentObject private var service: ExtensionService

        var body: some View {
            AddDetect(service.items) { loading, urls in
                Group {
                    if loading {
                        ProgressView()
                    } else {
                        AddStack(urls, to: -1)
                    }
                }
                    .presentationDetents([.medium])
                    .transition(.opacity)
                    .animation(.default, value: loading)
            }
        }
    }
}
