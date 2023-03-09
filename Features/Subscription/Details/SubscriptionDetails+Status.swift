import SwiftUI
import API
import UI

extension SubscriptionDetails {
    struct Status: View {
        var subscription: Subscription

        var body: some View {
            Section("") {
                EmptyState(subscription.plan.title, message: Text(subscription.status.title)) {
                    Image(systemName: subscription.status.systemImage)
                        .symbolVariant(.fill)
                        .foregroundColor(subscription.status.color)
                }
                    .frame(maxWidth: .infinity)
            }
                .clearSection()
            
            switch subscription.status {
            case .payment_failed:
                Admonition("We attempted to charge the card you have on file but were unable to do so.\n\nWe will automatically attempt to charge your card again within 24-48 hours.", role: .caution)
            case .deactivated:
                Admonition(role: .danger) {
                    Text("Your subscription has been **canceled**, but is active through ") +
                    Text(subscription.stopAt!, formatter: .shortDateTime) +
                    Text(".\n\nYou'll still be able to take advantage of PRO plan through this date, but you will not be charged a subscription fee moving forward.")
                }
            default:
                EmptyView()
            }
        }
    }
}
