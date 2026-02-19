import SwiftUI
import UI
import API

struct Ask: View {
    @StateObject private var page = WebPage()
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.openURL) private var openURL
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Binding var path: SplitViewPath

    private var aiChat: URL {
        var components = URLComponents(string: "https://beta-ai.raindrop.io/ai")!
        components.queryItems = [.init(name: "closable", value: "true")]

        switch path.detail.last {
        case .preview(_, let id), .cached(let id):
            components.queryItems?.append(.init(name: "raindropId", value: String(id)))
        default:
            break
        }

        return components.url!
    }
    
    private var ignoreSafeAreaRegions: SafeAreaRegions {
        if #available(iOS 26.0, *) {
            .container
        } else {
            .all
        }
    }

    var body: some View {
        ZStack {
            WebView(
                page,
                request: .init(aiChat, caching: .reloadRevalidatingCacheData),
                userAgent: "Raindrop",
                refreshable: false,
                autoAdjustInset: false
            )
                .onChange(of: path.ask) { _, next in
                    if next { page.focus() } else { page.blur() }
                }
                .ignoresSafeArea(ignoreSafeAreaRegions, edges: [.vertical])
                .opacity(page.progress)
                .onWebMessage(page, channel: "ai") { (event: Event) in
                    switch event {
                    case .linkClick(let dest):
                        if horizontalSizeClass == .compact {
                            path.ask = false
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
                        path.ask = false
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
                        if horizontalSizeClass == .compact { path.ask = false }
                        path.push(.preview(path.sidebar ?? .init(), id))
                    } else {
                        openURL(url)
                    }
                    
                    return .cancel
                }
            
            Image(systemName: "sparkle")
                .font(.largeTitle)
                .foregroundStyle(.tertiary)
                .opacity(1 - page.progress)
        }
            .navigationBarHidden(true)
            .presentationBackground(page.toolbarBackground ?? .clear)
            .presentationDetents([.large])
    }
}
