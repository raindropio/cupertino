import SwiftUI
import API
import UI

struct DeleteRaindrops: View {
    @EnvironmentObject private var dispatch: Dispatcher
    #if canImport(UIKit)
    @Environment(\.editMode) private var editMode
    #endif

    //props
    var pick: RaindropsPick
    
    //do work
    private func delete() {
        dispatch.sync(RaindropsAction.deleteMany(pick))
        #if canImport(UIKit)
        withAnimation {
            editMode?.wrappedValue = .inactive
        }
        #endif
    }
    
    var body: some View {
        Button(role: .destructive, action: delete) {
            Label("Delete \(pick.title)", systemImage: "trash")
        }
            .labelStyle(.titleAndIcon)
    }
}
