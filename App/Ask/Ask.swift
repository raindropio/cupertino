import SwiftUI
import UI
import API

struct Ask: View {
    @StateObject private var page = WebPage()
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.openURL) private var openURL
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.dismiss) private var dismiss
    private let aiChat = URL(string: "https://beta-ai.raindrop.io/ai?closable=true")!

    @Binding var path: SplitViewPath

    var body: some View {
        WebView(
            page,
            request: .init(aiChat, caching: .reloadRevalidatingCacheData),
            userAgent: "Raindrop",
            refreshable: false,
            autoAdjustInset: false
        )
            .ignoresSafeArea(.container, edges: [.vertical])
            .onWebMessage(page, channel: "ai") { (event: Event) in
                switch event {
                case .linkClick(let dest):
                    if horizontalSizeClass == .compact {
                        dismiss()
                    }
                    
                    if let raindropId = dest.raindropId {
                        path.push(.preview(path.sidebar ?? .init(), raindropId))
                    } else if let collectionId = dest.collectionId {
                        path.push(.find(.init(collectionId)))
                    } else if let tag = dest.tag {
                        path.push(.find(.init(0, filters: [.init(.tag(tag))])))
                    }
                    break
                    
                case .close:
                    dismiss()
                    break

                case .toolCalled:
                    Task {
                        try? await dispatch([
                            UserAction.reload,
                            CollectionsAction.reload,
                            FiltersAction.reload()
                        ])
                                                
                        if let find = path.sidebar {
                            try? await dispatch(RaindropsAction.reload(find))
                        }
                    }
                    break
                    
                case .unknown:
                    print("unknown web message")
                    break
                }
            }
            .decideWebViewNavigation { action, _ in
                guard let url = action.request.url, url.host() != aiChat.host() else { return .allow }

                if let match = url.path().firstMatch(of: /raindrop\/(\d+)\/link/), let id = Int(match.1) {
                    if horizontalSizeClass == .compact { dismiss() }
                    path.push(.preview(path.sidebar ?? .init(), id))
                } else {
                    openURL(url)
                }
                
                return .cancel
            }
            .navigationBarHidden(true)
            .presentationBackground(page.toolbarBackground ?? .clear)
    }
}
