import API

enum BrowserPage: Hashable {
    case collection(Collection)
    case search(String)
}
