import SwiftUI
import API
import UI

struct AddTagsRaindrops: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.dismiss) private var dismiss
    #if canImport(UIKit)
    @Environment(\.editMode) private var editMode
    #endif
    
    @State private var tags = [String]()

    //props
    var pick: RaindropsPick
    
    //do work
    private func add() async throws {
        guard !tags.isEmpty else { return }
        try await dispatch(RaindropsAction.updateMany(pick, .addTags(tags)))
        
        dismiss()
        #if canImport(UIKit)
        withAnimation {
            editMode?.wrappedValue = .inactive
        }
        #endif
    }
    
    var body: some View {
        TagsList($tags)
            .navigationTitle("Add \(tags.count) tags for \(pick.title)")
            #if canImport(UIKit)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    if !tags.isEmpty {
                        ActionButton("Confirm", action: add)
                            .fontWeight(.semibold)
                            .buttonStyle(.borderedProminent)
                            #if canImport(UIKit)
                            .buttonBorderShape(.capsule)
                            #endif
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: dismiss.callAsFunction)
                }
            }
    }
}
