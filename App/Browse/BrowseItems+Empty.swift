import SwiftUI
import API
import UI

extension BrowseItems {
    struct Empty: View {
        @EnvironmentObject private var r: RaindropsStore
        @EnvironmentObject private var dispatch: Dispatcher

        var find: FindBy
        
        var body: some View {
            Memorized(find: find, status: r.state.status(find))
        }
    }
}

extension BrowseItems.Empty {
    struct Memorized: View {
        @Environment(\.dismiss) private var dismiss
        @EnvironmentObject private var dispatch: Dispatcher

        var find: FindBy
        var status: RaindropsState.Segment.Status
        
        var body: some View {
            GroupBox {
                Group {
                    switch status {
                    case .idle:
                        if find.isSearching {
                            EmptyState(
                                message: "Your search - \(find.search) - did not match any items"
                            ) {
                                Image(systemName: "doc.text.magnifyingglass")
                            }
                        } else {
                            switch find.collectionId {
                            case -1:
                                EmptyState(
                                    message: "The Unsorted is your default collection in Raindrop.io. When you add an item, it goes straight to your Unsorted unless you specify that the item goes into a specific collection"
                                ) {
                                    Image(systemName: "tray")
                                }
                                
                            case -99:
                                EmptyState(
                                    message: "Trash is empty"
                                ) {
                                    Image(systemName: "trash.slash")
                                }
                                
                            default:
                                EmptyState(
                                    "No bookmarks yet",
                                    message: "See the big picture by bringing all your materials together From images to maps, videos to websites, Raindrop.io lets you save everything in a centralized and searchable place"
                                ) {
                                    Image(systemName: "star")
                                } actions: {
                                    SafariLink("Learn more", destination: URL(string: "https://help.raindrop.io/bookmarks")!)
                                }
                            }
                        }
                    
                    case .loading:
                        ProgressView()
                        
                    case .error:
                        EmptyState("Error loading collection") {
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
                            message: "Probably collection is deleted or you don't have permissions to view it"
                        ) {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundStyle(.yellow)
                        } actions: {
                            Button("Close", action: dismiss.callAsFunction)
                        }
                    }
                }
                    .frame(maxWidth: .infinity)
            }
                .scenePadding()
                .clearSection()
        }
    }
}
