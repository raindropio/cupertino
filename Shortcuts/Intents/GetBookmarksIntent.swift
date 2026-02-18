import AppIntents
import API

struct GetBookmarksIntent: AppIntent {
    static var title: LocalizedStringResource = "Get Bookmarks"
    static var description: IntentDescription = .init("Get or search bookmarks in Raindrop.io", categoryName: "Bookmarks")
    static var openAppWhenRun = false

    @Parameter(title: "Collection")
    var collection: CollectionEntity?

    @Parameter(title: "Search")
    var search: String?

    @Parameter(title: "Favorite Only")
    var favoriteOnly: Bool?

    @Parameter(title: "Sort By", default: .newestFirst)
    var sortBy: BookmarkSortOption

    @Parameter(title: "Limit", default: 50,
               controlStyle: .stepper, inclusiveRange: (1, 50))
    var limit: Int

    static var parameterSummary: some ParameterSummary {
        Summary("Get bookmarks") {
            \.$collection
            \.$search
            \.$favoriteOnly
            \.$sortBy
            \.$limit
        }
    }

    func perform() async throws -> some ReturnsValue<[BookmarkEntity]> {
        let bookmarks = try await IntentService.shared.perform { rest in
            var find = FindBy(collection?.id ?? 0, text: search ?? "")
            if favoriteOnly == true {
                find.filters.append(Filter(.important))
            }
            let (raindrops, _) = try await rest.raindropsGet(find, sort: sortBy.toSortBy)
            return Array(raindrops.prefix(limit)).map { BookmarkEntity(from: $0) }
        }
        return .result(value: bookmarks)
    }
}

enum BookmarkSortOption: String, AppEnum {
    case newestFirst, oldestFirst, titleAZ, titleZA

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Sort Order"
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .newestFirst: "Newest First",
        .oldestFirst: "Oldest First",
        .titleAZ: "Title (A to Z)",
        .titleZA: "Title (Z to A)"
    ]

    var toSortBy: SortBy {
        switch self {
        case .newestFirst: .created(.desc)
        case .oldestFirst: .created(.asc)
        case .titleAZ: .title(.asc)
        case .titleZA: .title(.desc)
        }
    }
}
