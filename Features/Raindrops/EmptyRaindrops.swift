import SwiftUI
import API
import UI

struct EmptyRaindrops: View {
    @EnvironmentObject private var dispatch: Dispatcher

    var find: FindBy
    var status: RaindropsState.Segment.Status
    
    var body: some View {
        Group {
            switch status {
            case .idle:
                Group {
                    if find.isSearching {
                        EmptyState(
                            message: Text("Your search **\(find.searchLocalized)** did not match any items")
                        ) {
                            Image(systemName: "doc.text.magnifyingglass")
                        }
                    } else {
                        switch find.collectionId {
                        case -1:
                            EmptyState(
                                message:
                                    Text("The **Unsorted** is your default collection in Raindrop.io.\n\n") +
                                    Text("When you add an item, it goes straight to your Unsorted unless you specify that the item goes into a specific collection")
                            ) {
                                Image(systemName: "tray")
                            }
                            
                        case -99:
                            EmptyState(
                                message: Text("**Trash** is empty")
                            ) {
                                Image(systemName: "trash.slash")
                            }
                            
                        default:
                            EmptyState(
                                "No items yet",
                                message: Text("Add links, media & files")
                            ) {
                                Image(systemName: "star")
                            } actions: {
                                SafariLink("Learn more", destination: URL(string: "https://help.raindrop.io/mobile-app")!)
                                    .tint(.secondary)
                                    .controlSize(.small)
                            }
                        }
                    }
                }
            
            case .loading:
                ProgressView()
                    .controlSize(.small)
                    .scenePadding()
                
            case .error:
                EmptyState("An error occurred while loading") {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundStyle(.red)
                } actions: {
                    Button("Try again") {
                        dispatch.sync(RaindropsAction.load(find))
                    }
                }
                
            case .notFound:
                EmptyState(
                    "Not found",
                    message: Text("The collection has been deleted or you do not have enough permissions to view it")
                ) {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundStyle(.yellow)
                } actions: {}
            }
        }
            .frame(maxWidth: .infinity)
            .clearSection()
            .scenePadding()
            .transition(.opacity)
            .contentTransition(.opacity)
            .animation(.default, value: status)
    }
}
