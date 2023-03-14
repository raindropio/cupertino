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
    @State private var loading = false

    //props
    var pick: RaindropsPick
    
    //do work
    private func move() async throws {
        guard let to else { return }
        loading = true
        defer { loading = false }
        
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
            .disabled(loading)
            .opacity(loading ? 0.5 : 1)
            .onChange(of: to) {
                //auto save when only one item selected
                guard $0 != nil, case let .some(ids) = pick, ids.count == 1 else { return }
                Task { try? await move() }
            }
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
