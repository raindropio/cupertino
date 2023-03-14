import SwiftUI
import API
import Features

extension SettingsExtensions {
    struct Action: View {
        @AppStorage(
            "action-default-collection",
            store: UserDefaults(suiteName: Constants.appGroupName)
        ) private var collection: Int = -1
        @State private var pick = false

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
                    
                    Button {
                        pick = true
                    } label: {
                        LabeledContent("Add to") {
                            CollectionLabel(collection, withLocation: true).badge(0)
                                .labelStyle(.titleAndIcon)
                                .controlSize(.small)
                                .fixedSize()
                            Image(systemName: "chevron.up.chevron.down")
                                .imageScale(.small)
                        }
                    }
                        .sheet(isPresented: $pick) {
                            DefaultCollection(collection: $collection)
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
            NavigationStack {
                CollectionsList($collection, system: [-1])
                    .collectionSheets()
                    .navigationTitle("Add to")
                    #if canImport(UIKit)
                    .navigationBarTitleDisplayMode(.inline)
                    #endif
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel", role: .cancel, action: dismiss.callAsFunction)
                        }
                    }
            }
                .onChange(of: collection) { _ in
                    dismiss()
                }
        }
    }
}
