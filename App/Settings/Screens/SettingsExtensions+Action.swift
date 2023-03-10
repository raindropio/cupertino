import SwiftUI
import API
import Features

extension SettingsExtensions {
    struct Action: View {
        @AppStorage(
            "action-default-collection",
            store: UserDefaults(suiteName: Constants.appGroupName)
        ) private var collection: Int = -1

        var body: some View {
            Section {
                Group {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Add to Collection Action", systemImage: "plus.rectangle.on.folder")
                            .fontWeight(.medium)
                        
                        Text("Quickly add new content to specific collection")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                        .labelStyle(.sidebar)
                        .listItemTint(.pink)
                    
                    NavigationLink {
                        DefaultCollection(collection: $collection)
                    } label: {
                        LabeledContent("Add to") {
                            CollectionLabel(collection, withLocation: true).badge(0)
                                .labelStyle(.titleOnly)
                                .fixedSize()
                        }
                    }
                }
                    .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
            }
        }
    }
}

extension SettingsExtensions.Action {
    struct DefaultCollection: View {
        @Environment(\.dismiss) private var dismiss
        @Binding var collection: Int
        
        var body: some View {
            CollectionsList($collection, system: [-1])
                .collectionSheets()
                .navigationTitle("Add to")
                .navigationBarTitleDisplayMode(.inline)
                .onChange(of: collection) { _ in
                    dismiss()
                }
        }
    }
}
