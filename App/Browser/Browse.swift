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
                case .link:
                    return .raw
                default:
                    return .preview
                }
            }()
            
            url = {
                switch mode {
                case .preview:
                    return Rest.raindropPreview(item.id, options: reader)
                case .cache:
                    return Rest.raindropCacheLink(id)
                case .raw:
                    return item.link
                }
            }()
            
        //some url
        case .url(let u):
            mode = .raw
            url = u
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
            case preview
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
