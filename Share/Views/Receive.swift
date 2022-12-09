import SwiftUI
import API
import Common
import Backport

struct Receive: View {
    @EnvironmentObject private var service: ExtensionService
    @State private var detent = BackportPresentationDetent.medium
    
    var body: some View {
        if let raindrop: Raindrop = service.decoded() {
            RaindropStack(raindrop)
        } else {
            AddDetect(service.items) { loading, urls in
                Group {
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
                        RaindropStack(first)
                            .onAppear {
                                detent = .large
                            }
                    }
                    //files
                    else {
                        SaveFiles(urls: urls)
                    }
                }
                    .backport.presentationDetents([.medium, .large], selection: $detent)
                    .presentationUndimmed(.medium)
                    .transition(.opacity)
                    .animation(.default, value: loading)
            }
        }
    }
}
