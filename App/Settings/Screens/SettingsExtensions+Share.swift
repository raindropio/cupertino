import SwiftUI
import UI
import API
import Features

extension SettingsExtensions {
    struct Share: View {
        var body: some View {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Label("Share Extension", systemImage: "square.and.arrow.up")
                        .fontWeight(.medium)
                    
                    Text("Recommended way to add new content from browser and apps")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                    .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                    .labelStyle(.sidebar)
                    .listItemTint(.red)
                
                DefaultCollection()
                
                SafariLink("Enable", destination: URL(string: "https://help.raindrop.io/mobile-app#share-ios")!)
            }
        }
    }
}

extension SettingsExtensions.Share {
    struct DefaultCollection: View {
        @AppStorage(
            "extension-default-collection",
            store: UserDefaults(suiteName: Constants.appGroupName)
        ) private var collection: Int = -1
        @State private var pick = false

        var body: some View {
            Button {
                pick = true
            } label: {
                LabeledContent("Default collection") {
                    CollectionLabel(collection, withLocation: true).badge(0)
                        .labelStyle(.titleAndIcon)
                        .controlSize(.small)
                        .fixedSize()
                    Image(systemName: "chevron.up.chevron.down")
                        .imageScale(.small)
                }
            }
                .tint(.primary)
                .sheet(isPresented: $pick) {
                    NavigationStack {
                        CollectionsList($collection, system: [-1])
                            .collectionSheets()
                            .navigationTitle("Add to")
                            #if canImport(UIKit)
                            .navigationBarTitleDisplayMode(.inline)
                            #endif
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("Cancel", role: .cancel) {
                                        pick = false
                                    }
                                }
                            }
                    }
                        .onChange(of: collection) { _ in
                            pick = false
                        }
                }
        }
    }
}
