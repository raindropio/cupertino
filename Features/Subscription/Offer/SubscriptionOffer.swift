import SwiftUI
import API
import UI
import Backport

public struct SubscriptionOffer: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var pro = true
    @State private var purchase = false
    
    public init() {}
    
    public var body: some View {
        List {
            Picker("Plan", selection: $pro) {
                Text("Free").tag(false)
                Text("Pro").tag(true)
            }
                .pickerStyle(.segmented)
                .clearSection()
            
            if pro {
                Pro()
            } else {
                Free()
            }
        }
            .animation(nil, value: pro)
            .safeAreaInset(edge: .bottom) {
                if pro {
                    Button {
                        purchase.toggle()
                    } label: {
                        Text("Subscribe Now")
                            .backport.fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .scenePadding()
                        .scenePadding(.horizontal)
                        .transition(.move(edge: .bottom).combined(with: .offset(y: 20)))
                }
            }
            .animation(.spring(), value: pro)
            .toolbar {
                ToolbarItem {
                    ActionButton("Restore") {
                        try await dispatch(SubscriptionAction.restore)
                    }
                }
            }
            .sheet(isPresented: $purchase, content: PurchaseStack.init)
    }
}
