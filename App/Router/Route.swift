import Foundation
import API

enum Route: Hashable {
    case browse(Collection, SearchQuery?)
    case tag(Tag)
    case filter(Filter)
    
    case search
    case preview(Raindrop)
}
