import SwiftUI
import API
import Features
import Backport

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
                                    .backport.presentationBackground(.clear)
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
                .frame(idealWidth: 600, idealHeight: 700)
                .presentationDetents([.fraction(0.75), .large])
                .presentationDragIndicator(.hidden)
                #else
                .frame(width: 400).frame(minHeight: 300)
                .fixedSize()
                #endif
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
                            .backport.presentationBackground(.clear)
                    }
                    //nothing found
                    else if urls.isEmpty {
                        NothingFound()
                    }
                    //add
                    else {
                        AddStack(urls)
                    }
                }
                    .transition(.opacity)
                    .animation(.default, value: loading)
            }
                #if canImport(UIKit)
                .presentationDetents([.fraction(0.333)])
                .backport.presentationBackground(.regularMaterial)
                .backport.presentationCompactAdaptation(.sheet)
                .frame(idealWidth: 400, idealHeight: 400)
                #else
                .frame(width: 400)
                .fixedSize()
                #endif
        }
    }
}
