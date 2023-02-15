import SwiftUI
import API
import UI

struct MoveRaindrops: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @EnvironmentObject private var c: CollectionsStore
    @Environment(\.dismiss) private var dismiss
    @Environment(\.editMode) private var editMode
    
    @State private var to: Int?

    //props
    var pick: RaindropsPick
    
    //do work
    private func move() async throws {
        guard let to else { return }
        try await dispatch(RaindropsAction.updateMany(pick, .moveTo(to)))
        self.to = nil
        dismiss()
        editMode?.wrappedValue = .inactive
    }
    
    var body: some View {
        CollectionsList($to, system: [-1, -99])
            .collectionSheets()
            .navigationTitle("Move to collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    if let to {
                        ActionButton("Move \(pick.title) to \(c.state.title(to))", action: move)
                            .fontWeight(.semibold)
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: dismiss.callAsFunction)
                }
            }
    }
}
