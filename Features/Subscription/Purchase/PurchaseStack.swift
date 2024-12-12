import SwiftUI
import UI
import API
import Backport
import StoreKit

struct PurchaseStack: View {
    @EnvironmentObject private var s: SubscriptionStore
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.dismiss) private var dismiss
    
    private var products: [Product] {
        s.state.products
    }
    
    var body: some View {
        Group {
            if products.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Products()
            }
        }
            .safeAnimation(.default, value: products.isEmpty)
            .reload {
                try? await dispatch(SubscriptionAction.products)
            }
            .tint(.red)
    }
}
