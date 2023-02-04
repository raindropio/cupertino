import SwiftUI
import API
import UI

struct AddTagsRaindrops: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var dispatch: Dispatcher
    
    @State private var tags = [String]()

    //props
    var pick: RaindropsPick
    
    //do work
    private func add() async throws {
        guard !tags.isEmpty else { return }
        try await dispatch(RaindropsAction.updateMany(pick, .addTags(tags)))
    }
    
    var body: some View {
        TagsList($tags)
            .navigationTitle("Add tags")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    if !tags.isEmpty {
                        ActionButton("Add \(tags.count) tags for \(pick.title)", action: add)
                            .fontWeight(.semibold)
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: dismiss.callAsFunction)
                }
            }
    }
}
