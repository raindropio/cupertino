import Foundation
import API

enum Route: Hashable {
    case browse(Collection, String)
    case search
    case tag(Tag)
    case filter(Filter)
    case preview(Raindrop)
}
