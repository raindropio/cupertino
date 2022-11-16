import SwiftUI
import API
import UI

extension RaindropsList {
    struct Menus: View {
        @EnvironmentObject private var r: RaindropsStore
        var selection: Set<Raindrop.ID>
        
        var body: some View {
            Memorized(items: selection.compactMap(r.state.item))
        }
    }
}

extension RaindropsList.Menus {
    struct Memorized: View {
        @EnvironmentObject private var app: AppRouter
        var items: [Raindrop]
        
        var body: some View {
            if items.count == 1, let item = items.first {
                Link(destination: item.link) {
                    Label("Open", systemImage: "safari")
                }
                
//                Button {
//                    
//                } label: {
//                    Label("Preview", systemImage: "eyeglasses")
//                }
                
                ShareLink(item: item.link)
                
                Button {
                } label: {
                    Label("Edit", systemImage: "pencil")
                }

                Button(role: .destructive) {
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
}
