import SwiftUI
import API
import UI

struct Browse: View {
    @EnvironmentObject private var r: RaindropsStore
    @AppStorage(ReaderOptions.StorageKey) private var reader = ReaderOptions()

    var location: Location
    
    private var request: WebRequest {
        var url: URL
        var canonical: URL?
        var mode: Location.Mode
        
        switch location.kind {
        //raindrop
        case .raindrop(let id):
            let item = r.state.item(id) ?? .new()
            
            canonical = item.link
            
            mode = location.mode ?? {
                switch item.type {
                case .article, .book:
                    return .article
                    
                case .audio, .document, .image, .video:
                    return .embed
                    
                default:
                    return .raw
                }
            }()
            
            url = {
                switch mode {
                case .article:
                    return Rest.previewArticle(item.link, options: reader)
                case .embed:
                    return Rest.previewEmbed(item.link)
                case .cache:
                    return Rest.raindropCacheLink(id)
                case .raw:
                    return item.link
                }
            }()
            
        //some url
        case .url(let u):
            canonical = u
            mode = location.mode ?? .raw
            url = {
                switch mode {
                case .article:
                    return Rest.previewArticle(u, options: reader)
                default:
                    return u
                }
            }()
        }
        
        return .init(url, canonical: canonical, caching: .returnCacheDataElseLoad, attribute: mode)
    }
    
    var body: some View {
        Browser(start: request)
            .id(location.id)
    }
}

extension Browse {
    struct Location: Identifiable, Hashable {
        var kind: Kind
        var mode: Mode?
        
        enum Kind: Hashable {
            case raindrop(Raindrop.ID)
            case url(URL)
        }
        
        enum Mode: String {
            case article
            case embed
            case cache
            case raw
        }
        
        var id: String {
            switch kind {
            case .raindrop(let id): return "\(id)\(mode?.rawValue ?? "")"
            case .url(let url): return "\(url.absoluteString)\(mode?.rawValue ?? "")"
            }
        }
    }
}
