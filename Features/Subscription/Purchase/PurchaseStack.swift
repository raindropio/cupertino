import SwiftUI
import UI
import API
import StoreKit

struct PurchaseStack: View {
    @EnvironmentObject private var s: SubscriptionStore
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.dismiss) private var dismiss
    
    private var products: [Product] {
        s.state.products
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if products.isEmpty {
                    ProgressView()
                        .controlSize(.small)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Products()
                }
            }
                .animation(.default, value: products.isEmpty)
                .reload {
                    try? await dispatch(SubscriptionAction.products)
                }
                .navigationTitle("Select billing cycle")
                #if canImport(UIKit)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(role: .cancel, action: dismiss.callAsFunction) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title3)
                        }
                            .foregroundStyle(.tertiary)
                    }
                }
        }
            .presentationDetents([.height(300)])
            .tint(.red)
    }
}
