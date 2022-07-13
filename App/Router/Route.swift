import Foundation
import API

enum Route: Hashable {
    case browse(Collection, String)
    case search
    case tag(String)
    case filter(String)
    case preview(Raindrop)
}
