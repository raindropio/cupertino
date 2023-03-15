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
            Group {
                if let item: Raindrop = service.decoded() {
                    RaindropStack(item, content: RaindropForm.init)
                } else {
                    AddDetect(service.items) { loading, urls in
                        Group {
                            //loading
                            if loading {
                                ProgressView()
                                    .controlSize(.small)
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
                #if canImport(UIKit)
                .frame(idealWidth: 400, idealHeight: 600)
                #else
                .frame(width: 400)
                .fixedSize()
                #endif
        }
    }
}

extension Receive {
    struct Action: View {
        @EnvironmentObject private var service: ExtensionService
        @AppStorage(
            "action-default-collection",
            store: UserDefaults(suiteName: Constants.appGroupName)
        ) private var collection: Int = -1

        var body: some View {
            AddDetect(service.items) { loading, urls in
                Group {
                    if loading {
                        ProgressView()
                            .controlSize(.small)
                    } else {
                        AddStack(urls, to: collection)
                    }
                }
                    .transition(.opacity)
                    .animation(.default, value: loading)
            }
                #if canImport(UIKit)
                .frame(idealWidth: 400, idealHeight: 400)
                #else
                .frame(width: 400)
                .fixedSize()
                #endif
        }
    }
}
