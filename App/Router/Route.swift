import Foundation
import API

enum Route: Hashable {
    case browse(Collection, SearchQuery?)
    case search
    case tag(Tag)
    case filter(Filter)
    case preview(Raindrop)
}
