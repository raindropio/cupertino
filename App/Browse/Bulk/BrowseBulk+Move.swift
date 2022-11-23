import SwiftUI
import API
import Common

extension BrowseBulk {
    struct Move: View {
        @EnvironmentObject private var dispatch: Dispatcher
        @EnvironmentObject private var c: CollectionsStore
        
        @State private var select = false
        @State private var to: Int?

        //props
        var pick: RaindropsPick
        var action: ( @escaping () async throws -> Void ) -> Void
        
        //do work
        private func move() {
            guard let to else { return }
            select = false
            action {
                try await dispatch(RaindropsAction.updateMany(pick, .moveTo(to)))
            }
            self.to = nil
        }
        
        //helpers
        private var title: String {
            "Move \(BrowseBulk.title(pick))"
        }
        
        private var confirm: Binding<Bool> {
            .init { to != nil }
            set: { if !$0 { to = nil } }
        }
        
        var body: some View {            
            Button {
                select = true
            } label: {
                Label("Move", systemImage: "folder")
            }
            //select
            .sheet(isPresented: $select) {
                NavigationStack {
                    CollectionsList(selection: $to, matching: .insertable, searchable: true)
                        .collectionActions()
                        .navigationTitle(title)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    select = false
                                }
                            }
                        }
                        .confirmationDialog("Are you sure?", isPresented: confirm, titleVisibility: .visible) {
                            Button("\(title) to \(c.state.title(to ?? -1))", action: move)
                        }
                }
                    .frame(idealWidth: 600, idealHeight: 800)
            }
        }
    }
}
