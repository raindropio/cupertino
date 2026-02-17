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
                    CollectionLabel(collection, withLocation: true)
                        .labelStyle(.titleAndIcon)
                        .controlSize(.small)
                        .fixedSize()
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
                                    Button("Cancel", systemImage: "xmark", role: .cancel) {
                                        pick = false
                                    }
                                        .labelStyle(.toolbar)
                                }
                            }
                    }
                        .onChange(of: collection) {
                            pick = false
                        }
                }
        }
    }
}
