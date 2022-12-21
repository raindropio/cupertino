import SwiftUI
import API
import UI

struct SettingsSubscription: View {
    @EnvironmentObject private var s: SubscriptionStore
    @EnvironmentObject private var dispatch: Dispatcher

    var body: some View {
        Group {
            if let subscription = s.state.current, subscription.status != .deactivated {
                SubscriptionDetails(subscription: subscription)
            } else {
                SubscriptionOffer()
            }
        }
            .navigationTitle("Subscription")
            .reload {
                try? await dispatch(SubscriptionAction.load)
            }
    }
}
