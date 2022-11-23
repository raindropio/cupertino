import SwiftUI
import API
import Common

extension BrowseBulk {
    struct AddTags: View {
        @EnvironmentObject private var dispatch: Dispatcher
        
        @State private var select = false
        @State private var tags = [String]()

        //props
        var pick: RaindropsPick
        var action: ( @escaping () async throws -> Void ) -> Void
        
        //do work
        private func add() {
            guard !tags.isEmpty else { return }
            select = false
            action {
                try await dispatch(RaindropsAction.updateMany(pick, .addTags(tags)))
            }
        }
        
        //helpers
        private var title: String {
            "Add tags for \(BrowseBulk.title(pick))"
        }
        
        var body: some View {
            Button {
                select = true
            } label: {
                Label("Add tags", systemImage: "number")
            }
            .sheet(isPresented: $select) {
                NavigationStack {
                    TagsPicker($tags)
                        .tokenFieldStyle(.inline)
                        .navigationTitle(title)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Save", action: add)
                            }
                            
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    select = false
                                }
                            }
                        }
                }
                    .frame(idealWidth: 600, idealHeight: 800)
            }
        }
    }
}
