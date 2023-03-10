import SwiftUI
import API
import UniformTypeIdentifiers

public extension View {
    func dropProvider() -> some View {
        modifier(DropProviderModifier())
    }
}

fileprivate struct DropProviderModifier: ViewModifier {
    @EnvironmentObject private var dispatch: Dispatcher

    @State private var urls = Set<URL>()
    @State private var collection = -1
    
    func onDrop(_ items: [NSItemProvider], _ collection: Int) {
        let raindropsDrag = items.contains {
            $0.hasItemConformingToTypeIdentifier(UTType.raindrop.identifier)
        }
        
        //only raindrops
        if raindropsDrag {
            Task {
                var ids = Set<Raindrop.ID>()
                for item in items {
                    if let raindrop = try? await item.loadTransferable(type: Raindrop.self) {
                        ids.insert(raindrop.id)
                    }
                }
                try? await dispatch(RaindropsAction.updateMany(.some(ids), .moveTo(collection)))
            }
        }
        //other nsitems
        else {
            self.collection = collection
            //make sure to get urls right away, otherwise OS kills nsitems in short time
            Task {
                self.urls = await items.urls()
            }
        }
    }
    
    func body(content: Content) -> some View {
        content
            .environment(\.drop, onDrop)
            .sheet(
                isPresented:
                    .init { !urls.isEmpty }
                    set: { if !$0 { urls = .init() } }
            ) {
                AddStack(urls, to: collection)
                    .presentationDetents([.height(200)])
            }
    }
}
