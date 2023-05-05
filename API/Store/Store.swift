import SwiftUI

public actor Store: ReduxStore {
    @MainActor public var dispatcher = Dispatcher()
    #if DEBUG
    @MainActor public var log = LogStore()
    #endif
    @MainActor public var auth = AuthStore()
    @MainActor public var collaborators = CollaboratorsStore()
    @MainActor public var collections = CollectionsStore()
    @MainActor public var config = ConfigStore()
    @MainActor public var filters = FiltersStore()
    @MainActor public var icons = IconsStore()
    @MainActor public var raindrops = RaindropsStore()
    @MainActor public var recent = RecentStore()
    @MainActor public var subscription = SubscriptionStore()
    @MainActor public var user = UserStore()

    @MainActor public init() {
        dispatcher.store = self
    }
    
    public func dispatch(_ some: Any) async throws {
        do {
            try await dispatch(some, store: \.log)
            try await dispatch(some, store: \.auth)
            try await dispatch(some, store: \.raindrops)
            try await dispatch(some, store: \.collections)
            try await dispatch(some, store: \.collaborators)
            try await dispatch(some, store: \.config)
            try await dispatch(some, store: \.filters)
            try await dispatch(some, store: \.icons)
            try await dispatch(some, store: \.recent)
            try await dispatch(some, store: \.subscription)
            try await dispatch(some, store: \.user)
        } catch {
            try await dispatch(error)
            throw error
        }
    }
}
