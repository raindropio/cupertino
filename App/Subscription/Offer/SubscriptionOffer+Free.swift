import SwiftUI
import UI
import Backport

extension SubscriptionOffer {
    struct Free: View {
        var body: some View {
            Section("Free forever") {
                FreeFeatures()
            }
        }
    }
}
