import SwiftUI
import API
import UI

struct AddTagsRaindrops: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.dismiss) private var dismiss
    @IsEditing private var isEditing
    
    @State private var tags = [String]()

    //props
    var pick: RaindropsPick
    
    //do work
    private func add() async throws {
        guard !tags.isEmpty else { return }
        try await dispatch(RaindropsAction.updateMany(pick, .addTags(tags)))
        
        dismiss()
        withAnimation {
            isEditing = false
        }
    }
    
    var body: some View {
        TagsList($tags)
            .navigationTitle("Add \(tags.count) tags for \(pick.title)")
            #if canImport(UIKit)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    if !tags.isEmpty {
                        ActionButton(action: add) {
                            Label("Confirm", systemImage: "checkmark")
                        }
                            .fontWeight(.semibold)
                            .labelStyle(.toolbar)
                    }
                }
                
                CancelToolbarItem()
            }
    }
}
