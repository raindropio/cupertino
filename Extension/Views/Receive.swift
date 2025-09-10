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
        @AppStorage("extension-default-collection", store: UserDefaults(suiteName: Constants.appGroupName)) private var collection: Int = -1
        
        var decoded: Raindrop? {
            var item: Raindrop? = service.decoded()
            item?.collection = collection
            return item
        }

        var body: some View {
            Group {
                if service.loading {
                    ProgressView()
                }
                else if let decoded {
                    RaindropStack(decoded, content: RaindropForm.init)
                } else {
                    AddDetect(service.items) { loading, urls in
                        //loading
                        if loading {
                            ProgressView()
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
                }
            }
                .presentationDetents(UIDevice.current.userInterfaceIdiom == .phone ? [.fraction(0.75), .large] : [.large])
                .presentationDragIndicator(.hidden)
        }
    }
}

extension Receive {
    struct Action: View {
        @EnvironmentObject private var service: ExtensionService

        var body: some View {
            AddDetect(service.items) { loading, urls in
                if service.loading || loading {
                    ProgressView()
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
                .presentationDetents(UIDevice.current.userInterfaceIdiom == .phone ? [.fraction(0.333)] : [.large])
                .presentationBackground(.regularMaterial)
                .presentationCompactAdaptation(.sheet)
                .transition(.opacity)
                .safeAnimation(.default, value: service.loading)
        }
    }
}
