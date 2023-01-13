import SwiftUI
import API
import Features
import Backport

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
        
        var body: some View {
            Button {
                select = true
            } label: {
                Label("Add tags", systemImage: "number")
            }
            .sheet(isPresented: $select) {
                Backport.NavigationStack {
                    TagsList($tags)
                        .navigationTitle("Add tags")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .bottomBar) {
                                if !tags.isEmpty {
                                    Button("Add \(tags.count) tags for \(BrowseBulk.title(pick))", action: add)
                                        .backport.fontWeight(.semibold)
                                }
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
