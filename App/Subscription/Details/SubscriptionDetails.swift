import SwiftUI
import API
import UI
import Backport

struct SubscriptionDetails: View {
    var subscription: Subscription
    
    var body: some View {
        Form {
            Status(subscription: subscription)
            
            Section {
                Group {
                    Label("Price", systemImage: "banknote")
                        .badge(subscription.price.beautiful)
                    
                    if let stopAt = subscription.stopAt {
                        Label("Will stop", systemImage: "calendar")
                            .badge(Text(stopAt, formatter: .shortDateTime))
                    } else if let renewAt = subscription.renewAt {
                        Label("Next payment", systemImage: "calendar")
                            .badge(Text(renewAt, formatter: .shortDateTime))
                    }
                }
                    .listItemTint(.monochrome)
                
                if let payments = subscription.links.payments {
                    SafariLink(destination: payments) {
                        Label("Payments history", systemImage: "clock.arrow.circlepath").tint(.primary)
                            .badge(Text(Image(systemName: "arrow.up.forward")))
                    }
                }
            }
            
            Section {
                DisclosureGroup {
                    ProFeatures()
                } label: {
                    Label("Premium features", systemImage: "circle.grid.2x2")
                }
                
                DisclosureGroup {
                    ProFaq()
                } label: {
                    Label("FAQ", systemImage: "questionmark.circle")
                }
                
                Help(subscription: subscription)
            }
            
            if let manage = subscription.links.manage {
                SafariLink(destination: manage) {
                    Text("Manage")
                        .frame(maxWidth: .infinity)
                        .backport.fontWeight(.medium)
                }
                    .tint(.white)
                    .listRowBackground(Color.accentColor)
            }
        }
            .symbolVariant(.fill)
    }
}
