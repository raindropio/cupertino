import SwiftUI
import API
import UI

public struct SubscriptionOffer: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var pro = true
    @State private var purchase = false
    
    public init() {}
    
    var form: some View {
        Form {
            Picker("Plan", selection: $pro) {
                Text("Free").tag(false)
                Text("Pro").tag(true)
            }
                .pickerStyle(.segmented)
                .labelsHidden()
                .clearSection()
            
            if pro {
                Pro()
            } else {
                Free()
            }
        }
    }
    
    public var body: some View {
        Group {
            #if canImport(UIKit)
            form.toolbar {
                ToolbarItem {
                    ActionButton("Restore") {
                        try await dispatch(SubscriptionAction.restore)
                    }
                }
            }
            #else
            ScrollView {
                form
            }
                .frame(idealHeight: 400)
            #endif
        }
            .animation(nil, value: pro)
            .safeAreaInset(edge: .bottom) {
                if pro {
                    HStack {
                        #if canImport(AppKit)
                        ActionButton("Restore") {
                            try await dispatch(SubscriptionAction.restore)
                        }
                            .background(.bar)
                        #endif
                        
                        Button {
                            purchase.toggle()
                        } label: {
                            Text("Subscribe Now")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                        }
                            .buttonStyle(.borderedProminent)
                    }
                        .controlSize(.large)
                        .scenePadding()
                        .scenePadding(.horizontal)
                        .transition(.move(edge: .bottom).combined(with: .offset(y: 20)))
                }
            }
            .animation(.spring(), value: pro)
            
            .sheet(isPresented: $purchase, content: PurchaseStack.init)
    }
}
