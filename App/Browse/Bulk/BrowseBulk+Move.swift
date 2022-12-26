import SwiftUI
import API
import Common
import Backport

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
                Backport.NavigationStack {
                    CollectionPicker($to, system: [-1, -99])
                        .navigationTitle("Select collection")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .bottomBar) {
                                if let to {
                                    Button("Move \(BrowseBulk.title(pick)) to \(c.state.title(to))", action: move)
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
