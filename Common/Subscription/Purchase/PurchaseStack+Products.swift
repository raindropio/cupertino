import SwiftUI
import Backport
import UI
import API
import StoreKit

extension PurchaseStack {
    struct Products: View {
        @Environment(\.dismiss) private var dismiss
        @EnvironmentObject private var s: SubscriptionStore
        @EnvironmentObject private var u: UserStore
        @EnvironmentObject private var dispatch: Dispatcher
        
        private var products: [Product] {
            s.state.products
        }
        
        var body: some View {
            List {
                Section {
                    ForEach(products) { product in
                        ActionButton {
                            try await dispatch(SubscriptionAction.purchase(u.state.me!.id, product))
                            dismiss()
                        } label: {
                            Label(product.displayName, systemImage: "bolt.fill").tint(.primary)
                        }
                            .badge(product.displayPrice)
                    }
                } footer: {
                    Text("\nAuto-renewable. You will get access to all features in all supported platforms.\n\n") +
                    Text("All content you made in PRO remains available in free when subscription is canceled.")
                }
            }
        }
    }
}
