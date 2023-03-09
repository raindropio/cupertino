import SwiftUI
import API
import UI

struct AddTagsRaindrops: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.dismiss) private var dismiss
    @Environment(\.editMode) private var editMode
    
    @State private var tags = [String]()

    //props
    var pick: RaindropsPick
    
    //do work
    private func add() async throws {
        guard !tags.isEmpty else { return }
        try await dispatch(RaindropsAction.updateMany(pick, .addTags(tags)))
        
        dismiss()
        withAnimation {
            editMode?.wrappedValue = .inactive
        }
    }
    
    var body: some View {
        TagsList($tags)
            .navigationTitle("Add \(tags.count) tags for \(pick.title)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    if !tags.isEmpty {
                        ActionButton("Confirm", action: add)
                            .fontWeight(.semibold)
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.capsule)
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: dismiss.callAsFunction)
                }
            }
    }
}
