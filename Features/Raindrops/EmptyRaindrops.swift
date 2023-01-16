import SwiftUI
import API
import UI

struct EmptyRaindrops: View {
    @EnvironmentObject private var dispatch: Dispatcher

    var find: FindBy
    var status: RaindropsState.Segment.Status
    
    var body: some View {
        switch status {
        case .idle:
            Group {
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
                            "No bookmarks yet"
                        ) {
                            Image(systemName: "star")
                        } actions: {
                            SafariLink("Learn more", destination: URL(string: "https://help.raindrop.io/bookmarks")!)
                        }
                    }
                }
            }
                .modifier(Clear())
        
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
                .modifier(Clear())
            
        case .notFound:
            EmptyState(
                "Not found",
                message: "Probably collection is deleted or you don't have permissions to view it"
            ) {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundStyle(.yellow)
            } actions: {}
                .modifier(Clear())
        }
    }
}

extension EmptyRaindrops {
    struct Clear: ViewModifier {
        func body(content: Content) -> some View {
            GroupBox {
                content
                    .frame(maxWidth: .infinity)
            }
                .scenePadding()
                .clearSection()
        }
    }
}
