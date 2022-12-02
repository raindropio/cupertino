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
        
        var body: some View {
            Button {
                select = true
            } label: {
                Label("Add tags", systemImage: "number")
            }
            .sheet(isPresented: $select) {
                NavigationView {
                    TagsPicker($tags)
                        .tokenFieldStyle(.inline)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add \(tags.count) tags for \(BrowseBulk.title(pick))", action: add)
                                    .disabled(tags.isEmpty)
                            }
                            
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    select = false
                                }
                            }
                        }
                }
                    .navigationViewStyle(.stack)
                    .frame(idealWidth: 600, idealHeight: 800)
            }
        }
    }
}
