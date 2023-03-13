import SwiftUI
import API
import UI

struct MoveRaindrops: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.dismiss) private var dismiss
    #if canImport(UIKit)
    @Environment(\.editMode) private var editMode
    #endif
    
    @State private var to: Int?

    //props
    var pick: RaindropsPick
    
    //do work
    private func move() async throws {
        guard let to else { return }
        try await dispatch(RaindropsAction.updateMany(pick, .moveTo(to)))
        self.to = nil
        dismiss()
        
        #if canImport(UIKit)
        withAnimation {
            editMode?.wrappedValue = .inactive
        }
        #endif
    }
    
    var body: some View {
        CollectionsList($to, system: [-1, -99])
            .collectionSheets()
            .navigationTitle("Move \(pick.title)")
            #if canImport(UIKit)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    if to != nil {
                        ActionButton("Confirm", action: move)
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
