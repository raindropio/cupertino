import API

extension PreviewScreen {
    enum Mode: Int {
        case article
        case embed
        case cache
        case raw
        
        init(_ raindrop: Raindrop) {
            switch raindrop.type {
            case .article:
                self = .article
                
            case .audio, .document, .image, .video:
                self = .embed
                
            default:
                self = .raw
            }
        }
    }
}
