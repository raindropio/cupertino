import SwiftUI

public extension View {
    func itemDestination<I: Identifiable>(for: I.Type, perform: @escaping (I.ID) -> Void) -> some View {
        modifier(JustItem<I>(perform: perform))
    }
    
    func itemDestination<I: Identifiable>(_ kind: String, for: I.Type, perform: @escaping (I.ID) -> Void) -> some View {
        modifier(ItemKind<I>(kind: kind, perform: perform))
    }
}

fileprivate struct JustItem<I: Identifiable>: ViewModifier {
    @StateObject private var service = ItemLinkService<I>()
    var perform: (I.ID) -> Void
    
    func body(content: Content) -> some View {
        content.onReceive(service.publisher) {
            if $0.kind == nil {
                perform($0.id)
            }
        }
        .environmentObject(service)
    }
}

fileprivate struct ItemKind<I: Identifiable>: ViewModifier {
    @EnvironmentObject private var service: ItemLinkService<I>
    var kind: String
    var perform: (I.ID) -> Void
    
    func body(content: Content) -> some View {
        content.onReceive(service.publisher) {
            if $0.kind == kind {
                perform($0.id)
            }
        }
    }
}
