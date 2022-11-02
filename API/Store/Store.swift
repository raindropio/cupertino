import SwiftUI

public actor Store: ReduxStore {
    @MainActor public var log = LogStore()
    @MainActor public var auth = AuthStore()
    @MainActor public var collections = CollectionsStore()
    @MainActor public var filters = FiltersStore()
    @MainActor public var icons = IconsStore()
    @MainActor public var raindrops = RaindropsStore()
    @MainActor public var recent = RecentStore()
    @MainActor public var user = UserStore()

    @MainActor public init() {
        bind()
    }
    
    @MainActor private func bind() {
        log.store = self
        auth.store = self
        collections.store = self
        filters.store = self
        icons.store = self
        raindrops.store = self
        recent.store = self
        user.store = self
    }
    
    func dispatch(_ some: Any) async throws {
        do {
            try await dispatch(some, store: \.log)
            try await dispatch(some, store: \.auth)
            try await dispatch(some, store: \.raindrops)
            try await dispatch(some, store: \.collections)
            try await dispatch(some, store: \.filters)
            try await dispatch(some, store: \.icons)
            try await dispatch(some, store: \.recent)
            try await dispatch(some, store: \.user)
        } catch {
            try await dispatch(error)
            throw error
        }
    }
}
