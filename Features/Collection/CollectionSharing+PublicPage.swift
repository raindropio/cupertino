import SwiftUI
import API
import UI

extension CollectionSharing {
    struct PublicPage: View {
        @Binding var collection: UserCollection
        
        var body: some View {
            Section {
                if collection.public {
                    Group {
                        SafariLink(destination: collection.publicPage) {
                            Label("Open", systemImage: "safari").tint(.primary)
                        }
                        ShareLink(item: collection.publicPage) {
                            Label("Share", systemImage: "square.and.arrow.up").tint(.primary)
                        }
                    }
                        .symbolVariant(.fill)
                }
            } header: {
                HStack {
                    Text("Public page")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Toggle("", isOn: $collection.public)
                        .toggleStyle(.switch)
                }
            } footer: {
                Text("Share collection with the entire web. Sign-up is not required. [Learn more](https://help.raindrop.io/public-page/)")
                    .padding(.bottom)
            }
                .listItemTint(.monochrome)
        }
    }
}
