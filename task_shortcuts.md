# Apple Shortcuts (App Intents) — Задачи

> Все файлы в `Shortcuts/` (отдельная папка на уровне `Extension/`). Используем **App Intents** (iOS 16+ / macOS 13+).
> REST API (`Rest`) используется напрямую без Redux Store.

---

## Структура файлов

```
Shortcuts/
  IntentService.swift
  Entities/
    BookmarkEntity.swift
    CollectionEntity.swift
  Queries/
    BookmarkQuery.swift
    CollectionQuery.swift
  Intents/
    SaveBookmarkIntent.swift
    GetBookmarksIntent.swift
    GetCollectionsIntent.swift
    CreateCollectionIntent.swift
    UpdateBookmarkIntent.swift
    DeleteBookmarkIntent.swift
  AppShortcutsProvider.swift
```

---

## Task 0: Извлечь `restore()`/`persist()` в общий модуль

**Файл:** `API/Keychain/KeychainCookies.swift` (новый)

Вынести из `AuthReducer+keychain.swift` в переиспользуемый enum.

```swift
import Foundation

public enum KeychainCookies {
    public static func restore() {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "raindrop",
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecAttrAccessGroup: Constants.keychainGroupName
        ] as [CFString : Any] as CFDictionary

        var raw: AnyObject?
        let status = SecItemCopyMatching(query, &raw)
        guard
            status == errSecSuccess,
            let data = raw as? Data,
            let cookies = try? NSKeyedUnarchiver.unarchivedObject(
                ofClasses: [NSArray.self, HTTPCookie.self], from: data
            ) as? [HTTPCookie]
        else { return }

        for cookie in cookies {
            HTTPCookieStorage.shared.setCookie(cookie)
        }
    }

    public static func persist() {
        let cookies = (HTTPCookieStorage.shared.cookies ?? []).filter {
            $0.domain.contains(Rest.base.root.host!) ||
            $0.domain.contains(Rest.base.api.host!)
        }
        guard !cookies.isEmpty else { return }

        let data = try? NSKeyedArchiver.archivedData(withRootObject: cookies, requiringSecureCoding: false)
        guard let data else { return }

        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "raindrop",
            kSecValueData: data,
            kSecAttrAccessGroup: Constants.keychainGroupName
        ] as [CFString : Any] as CFDictionary
        SecItemDelete(query)
        SecItemAdd(query, nil)
    }
}
```

Обновить `AuthReducer+keychain.swift`:
```swift
extension AuthReducer {
    func restore() { KeychainCookies.restore() }
    func persist() { KeychainCookies.persist() }
}
```

- [ ] Реализовано

---

## Task 1: IntentService

**Файл:** `Shortcuts/IntentService.swift`

```swift
import AppIntents
import API

enum IntentServiceError: Error, CustomLocalizedStringResourceConvertible {
    case notAuthenticated

    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .notAuthenticated: "Please log in to Raindrop.io first"
        }
    }
}

final class IntentService {
    static let shared = IntentService()

    let rest = Rest()
    private var cookiesRestored = false

    private init() {}

    func perform<T>(_ block: (Rest) async throws -> T) async throws -> T {
        if !cookiesRestored {
            KeychainCookies.restore()
            cookiesRestored = true
        }
        do {
            _ = try await rest.userGet()
        } catch {
            throw IntentServiceError.notAuthenticated
        }
        return try await block(rest)
    }
}
```

- [ ] Реализовано

---

## Task 2: BookmarkEntity

**Файл:** `Shortcuts/Entities/BookmarkEntity.swift`

**Референс:** `API/Models/Raindrop/Raindrop.swift`

```swift
import AppIntents
import API

struct BookmarkEntity: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Bookmark"
    static var defaultQuery = BookmarkQuery()

    var id: Int

    @Property(title: "Title")         var title: String
    @Property(title: "URL")           var link: URL
    @Property(title: "Note")          var note: String
    @Property(title: "Tags")          var tags: [String]
    @Property(title: "Collection ID") var collectionId: Int
    @Property(title: "Favorite")      var important: Bool
    @Property(title: "Created")       var created: Date

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)",
            subtitle: "\(link.host ?? link.absoluteString)"
        )
    }

    init(from raindrop: Raindrop) {
        self.id = raindrop.id
        self.title = raindrop.title
        self.link = raindrop.link
        self.note = raindrop.note
        self.tags = raindrop.tags
        self.collectionId = raindrop.collection
        self.important = raindrop.important
        self.created = raindrop.created
    }
}
```

- [ ] Реализовано

---

## Task 3: CollectionEntity

**Файл:** `Shortcuts/Entities/CollectionEntity.swift`

**Референс:** `CollectionType` протокол — уже имеет `systemImage`

```swift
import AppIntents
import API

struct CollectionEntity: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Collection"
    static var defaultQuery = CollectionQuery()

    var id: Int

    @Property(title: "Title") var title: String
    @Property(title: "Count") var count: Int

    private var systemImage: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)",
            subtitle: "\(count) items",
            image: .init(systemName: systemImage)
        )
    }

    init(from collection: some CollectionType) {
        self.id = collection.id
        self.title = collection.title
        self.count = collection.count
        self.systemImage = collection.systemImage
    }
}
```

- [ ] Реализовано

---

## Task 4: CollectionQuery

**Файл:** `Shortcuts/Queries/CollectionQuery.swift`

```swift
import AppIntents
import API

struct CollectionQuery: EntityStringQuery {
    func entities(for identifiers: [Int]) async throws -> [CollectionEntity] {
        try await IntentService.shared.perform { rest in
            let (system, user) = try await rest.collectionsGet()
            let all: [any CollectionType] = system + user
            return identifiers.compactMap { id in
                all.first(where: { $0.id == id }).map { CollectionEntity(from: $0) }
            }
        }
    }

    func entities(matching string: String) async throws -> [CollectionEntity] {
        try await IntentService.shared.perform { rest in
            let (system, user) = try await rest.collectionsGet()
            let all: [any CollectionType] = system + user
            let lowered = string.lowercased()
            return all.filter { $0.title.lowercased().contains(lowered) }
                      .map { CollectionEntity(from: $0) }
        }
    }

    func suggestedEntities() async throws -> [CollectionEntity] {
        try await IntentService.shared.perform { rest in
            let (system, user) = try await rest.collectionsGet()
            return (system as [any CollectionType] + user)
                .map { CollectionEntity(from: $0) }
        }
    }
}
```

- [ ] Реализовано

---

## Task 5: BookmarkQuery

**Файл:** `Shortcuts/Queries/BookmarkQuery.swift`

```swift
import AppIntents
import API

struct BookmarkQuery: EntityStringQuery {
    func entities(for identifiers: [Int]) async throws -> [BookmarkEntity] {
        try await IntentService.shared.perform { rest in
            var results: [BookmarkEntity] = []
            for id in identifiers {
                if let raindrop = try await rest.raindropGet(id: id) {
                    results.append(.init(from: raindrop))
                }
            }
            return results
        }
    }

    func entities(matching string: String) async throws -> [BookmarkEntity] {
        try await IntentService.shared.perform { rest in
            let find = FindBy(0, text: string)
            let (raindrops, _) = try await rest.raindropsGet(find, sort: .score)
            return raindrops.map { BookmarkEntity(from: $0) }
        }
    }

    func suggestedEntities() async throws -> [BookmarkEntity] {
        try await IntentService.shared.perform { rest in
            let find = FindBy(0)
            let (raindrops, _) = try await rest.raindropsGet(find, sort: .created(.desc))
            return raindrops.prefix(25).map { BookmarkEntity(from: $0) }
        }
    }
}
```

- [ ] Реализовано

---

## Task 6: SaveBookmarkIntent

**Файл:** `Shortcuts/Intents/SaveBookmarkIntent.swift`

**Референс:** `Raindrop.new()` — устанавливает `pleaseParse`, сервер парсит метаданные. Коллекция по умолчанию = Unsorted (-1).

```swift
import AppIntents
import API

struct SaveBookmarkIntent: AppIntent {
    static var title: LocalizedStringResource = "Save Bookmark"
    static var description: IntentDescription = "Save a URL to Raindrop.io"
    static var openAppWhenRun = false

    @Parameter(title: "URL")
    var url: URL

    @Parameter(title: "Title")
    var title: String?

    @Parameter(title: "Collection")
    var collection: CollectionEntity?

    @Parameter(title: "Tags")
    var tags: [String]?

    static var parameterSummary: some ParameterSummary {
        Summary("Save \(\.$url) to Raindrop.io") {
            \.$title
            \.$collection
            \.$tags
        }
    }

    func perform() async throws -> some ReturnsValue<BookmarkEntity> {
        try await IntentService.shared.perform { rest in
            var raindrop = Raindrop.new(link: url, collection: collection?.id)

            if let title, !title.isEmpty { raindrop.title = title }
            if let tags, !tags.isEmpty { raindrop.tags = tags }

            let created = try await rest.raindropCreate(raindrop: raindrop)
            return .result(value: BookmarkEntity(from: created))
        }
    }
}
```

- [ ] Реализовано

---

## Task 7: GetBookmarksIntent

**Файл:** `Shortcuts/Intents/GetBookmarksIntent.swift`

Если указан `searchText` — поиск по релевантности, иначе — листинг с сортировкой.

```swift
import AppIntents
import API

struct GetBookmarksIntent: AppIntent {
    static var title: LocalizedStringResource = "Get Bookmarks"
    static var description: IntentDescription = "Get or search bookmarks in Raindrop.io"
    static var openAppWhenRun = false

    @Parameter(title: "Collection")
    var collection: CollectionEntity?

    @Parameter(title: "Search Text")
    var searchText: String?

    @Parameter(title: "Sort By", default: .newestFirst)
    var sortBy: BookmarkSortOption

    @Parameter(title: "Maximum Results", default: 25,
               controlStyle: .stepper, inclusiveRange: (1, 50))
    var maxResults: Int

    static var parameterSummary: some ParameterSummary {
        Summary("Get bookmarks") {
            \.$collection
            \.$searchText
            \.$sortBy
            \.$maxResults
        }
    }

    func perform() async throws -> some ReturnsValue<[BookmarkEntity]> {
        try await IntentService.shared.perform { rest in
            let collectionId = collection?.id ?? 0

            let sort: SortBy
            let find: FindBy

            if let searchText, !searchText.isEmpty {
                find = FindBy(collectionId, text: searchText)
                sort = .score
            } else {
                find = FindBy(collectionId)
                sort = sortBy.toSortBy
            }

            let (raindrops, _) = try await rest.raindropsGet(find, sort: sort)
            return .result(value: Array(raindrops.prefix(maxResults)).map { BookmarkEntity(from: $0) })
        }
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
```

- [ ] Реализовано

---

## Task 8: GetCollectionsIntent + CreateCollectionIntent

**Файлы:** `Shortcuts/Intents/GetCollectionsIntent.swift`, `Shortcuts/Intents/CreateCollectionIntent.swift`

```swift
import AppIntents
import API

struct GetCollectionsIntent: AppIntent {
    static var title: LocalizedStringResource = "Get Collections"
    static var description: IntentDescription = "List all Raindrop.io collections"
    static var openAppWhenRun = false

    func perform() async throws -> some ReturnsValue<[CollectionEntity]> {
        try await IntentService.shared.perform { rest in
            let (system, user) = try await rest.collectionsGet()
            return .result(value:
                (system as [any CollectionType] + user).map { CollectionEntity(from: $0) }
            )
        }
    }
}
```

```swift
struct CreateCollectionIntent: AppIntent {
    static var title: LocalizedStringResource = "Create Collection"
    static var description: IntentDescription = "Create a new collection in Raindrop.io"
    static var openAppWhenRun = false

    @Parameter(title: "Title")
    var title: String

    static var parameterSummary: some ParameterSummary {
        Summary("Create collection \(\.$title)")
    }

    func perform() async throws -> some ReturnsValue<CollectionEntity> {
        try await IntentService.shared.perform { rest in
            var collection = UserCollection.new()
            collection.title = title

            let created = try await rest.collectionCreate(collection: collection)
            return .result(value: CollectionEntity(from: created))
        }
    }
}
```

- [ ] Реализовано

---

## Task 9: UpdateBookmarkIntent

**Файл:** `Shortcuts/Intents/UpdateBookmarkIntent.swift`

**Референс:** `raindropUpdate(original:modified:)` — отправляет только diff

```swift
import AppIntents
import API

struct UpdateBookmarkIntent: AppIntent {
    static var title: LocalizedStringResource = "Update Bookmark"
    static var description: IntentDescription = "Update tags or favorite status of a bookmark"
    static var openAppWhenRun = false

    @Parameter(title: "Bookmark")
    var bookmark: BookmarkEntity

    @Parameter(title: "Add Tags")
    var addTags: [String]?

    @Parameter(title: "Remove Tags")
    var removeTags: [String]?

    @Parameter(title: "Favorite")
    var important: Bool?

    static var parameterSummary: some ParameterSummary {
        Summary("Update \(\.$bookmark)") {
            \.$addTags
            \.$removeTags
            \.$important
        }
    }

    func perform() async throws -> some ReturnsValue<BookmarkEntity> {
        try await IntentService.shared.perform { rest in
            guard let original = try await rest.raindropGet(id: bookmark.id) else {
                throw IntentServiceError.notAuthenticated
            }

            var modified = original

            if let addTags, !addTags.isEmpty {
                let existingLower = Set(modified.tags.map { $0.lowercased() })
                modified.tags += addTags.filter { !existingLower.contains($0.lowercased()) }
            }

            if let removeTags, !removeTags.isEmpty {
                let removeLower = Set(removeTags.map { $0.lowercased() })
                modified.tags = modified.tags.filter { !removeLower.contains($0.lowercased()) }
            }

            if let important {
                modified.important = important
            }

            let updated = try await rest.raindropUpdate(original: original, modified: modified)
            return .result(value: BookmarkEntity(from: updated))
        }
    }
}
```

- [ ] Реализовано

---

## Task 10: DeleteBookmarkIntent

**Файл:** `Shortcuts/Intents/DeleteBookmarkIntent.swift`

```swift
import AppIntents
import API

struct DeleteBookmarkIntent: AppIntent {
    static var title: LocalizedStringResource = "Delete Bookmark"
    static var description: IntentDescription = "Move a bookmark to trash"
    static var openAppWhenRun = false

    @Parameter(title: "Bookmark")
    var bookmark: BookmarkEntity

    static var parameterSummary: some ParameterSummary {
        Summary("Delete \(\.$bookmark)")
    }

    func perform() async throws -> some IntentResult {
        try await IntentService.shared.perform { rest in
            try await rest.raindropDelete(id: bookmark.id)
            return .result()
        }
    }
}
```

- [ ] Реализовано

---

## Task 11: AppShortcutsProvider

**Файл:** `Shortcuts/AppShortcutsProvider.swift`

```swift
import AppIntents

struct ShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: SaveBookmarkIntent(),
            phrases: [
                "Save bookmark in \(.applicationName)",
                "Save to \(.applicationName)",
                "Add bookmark to \(.applicationName)"
            ],
            shortTitle: "Save Bookmark",
            systemImageName: "bookmark.fill"
        )

        AppShortcut(
            intent: GetBookmarksIntent(),
            phrases: [
                "Search \(.applicationName)",
                "Search bookmarks in \(.applicationName)",
                "Find in \(.applicationName)",
                "Get bookmarks from \(.applicationName)"
            ],
            shortTitle: "Get Bookmarks",
            systemImageName: "magnifyingglass"
        )

        AppShortcut(
            intent: GetCollectionsIntent(),
            phrases: [
                "Show my \(.applicationName) collections",
                "List collections in \(.applicationName)"
            ],
            shortTitle: "Collections",
            systemImageName: "folder"
        )
    }
}
```

Добавить в `App.swift`:
```swift
.task { ShortcutsProvider.updateAppShortcutParameters() }
```

- [ ] Реализовано

---

## Нюансы

- `Rest` и `Fetch` не `Sendable` — при strict concurrency возможны warnings, добавить `@unchecked Sendable` при необходимости
- Cookies из Keychain через `accessGroup: "7459JWM5TY.secrets"`
