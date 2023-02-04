import SwiftUI
import UI

extension SubscriptionOffer {
    struct Free: View {
        var body: some View {
            Section("Free forever") {
                FreeFeatures()
            }
        }
    }
}
