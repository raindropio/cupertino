import API

enum SidebarSelection: Hashable {
    case collection(Collection)
    case filter(Filter)
    case tag(Tag)
}
