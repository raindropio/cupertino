import SwiftUI
import API
import UI

extension SubscriptionDetails {
    struct Help: View {
        var subscription: Subscription

        var body: some View {
            DisclosureGroup {
                SafariLink(destination: URL(string: "https://help.raindrop.io/change-billing-cycle")!) {
                    Label("Change billing cycle", systemImage: "clock").tint(.primary)
                }
                
                SafariLink(destination: URL(string: "https://help.raindrop.io/cancel")!) {
                    Label("Cancel subscription", systemImage: "heart.slash").tint(.primary)
                }
                
                SafariLink(destination: URL(string: "https://help.raindrop.io/refund")!) {
                    Label("Refund", systemImage: "arrow.down.left.circle").tint(.primary)
                }
            } label: {
                Label("Help", systemImage: "lifepreserver")
            }
        }
    }
}
