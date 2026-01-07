import SwiftUI

@MainActor
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
            // Sequential: Log → Auth → User (dependency chain for auth/cookies)
            try await process(some, store: \.log)
            try await process(some, store: \.auth)
            try await process(some, store: \.user)

            // Parallel: remaining stores (all have valid auth state)
            try await withThrowingTaskGroup(of: Void.self) { group in
                group.addTask { try await self.process(some, store: \.raindrops) }
                group.addTask { try await self.process(some, store: \.collections) }
                group.addTask { try await self.process(some, store: \.collaborators) }
                group.addTask { try await self.process(some, store: \.config) }
                group.addTask { try await self.process(some, store: \.filters) }
                group.addTask { try await self.process(some, store: \.icons) }
                group.addTask { try await self.process(some, store: \.recent) }
                group.addTask { try await self.process(some, store: \.subscription) }
                try await group.waitForAll()
            }
        } catch {
            try await dispatch(error)
            throw error
        }
    }
}
