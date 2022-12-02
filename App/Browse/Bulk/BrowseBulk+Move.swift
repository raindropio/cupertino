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
        
        var body: some View {            
            Button {
                select = true
            } label: {
                Label("Move", systemImage: "folder")
            }
            //select
            .sheet(isPresented: $select) {
                NavigationView {
                    CollectionsList(selection: $to, matching: .insertable, searchable: true)
                        .collectionActions()
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Move \(BrowseBulk.title(pick)) to \(c.state.title(to ?? -1))", action: move)
                                    .lineLimit(1)
                                    .disabled(to == nil)
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
