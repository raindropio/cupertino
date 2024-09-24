import SwiftUI

public final class Store: ObservableObject, ReduxStore {
    @Published public var dispatcher = Dispatcher()
    @Published public var log = LogStore()
    @Published public var auth = AuthStore()
    @Published public var collaborators = CollaboratorsStore()
    @Published public var collections = CollectionsStore()
    @Published public var config = ConfigStore()
    @Published public var filters = FiltersStore()
    @Published public var icons = IconsStore()
    @Published public var raindrops = RaindropsStore()
    @Published public var recent = RecentStore()
    @Published public var subscription = SubscriptionStore()
    @Published public var user = UserStore()

    public init() {
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
