import SwiftUI
import API
import UI

struct DeleteRaindrops: View {
    @EnvironmentObject private var dispatch: Dispatcher
    
    //props
    var pick: RaindropsPick
    
    //do work
    private func delete() {
        dispatch.sync(RaindropsAction.deleteMany(pick))
    }
    
    var body: some View {
        Button(role: .destructive, action: delete) {
            Label("Delete \(pick.title)", systemImage: "trash")
        }
            .labelStyle(.titleAndIcon)
    }
}
