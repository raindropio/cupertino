import SwiftUI

public struct ItemLink<I: Identifiable, L: View>: View {
    @EnvironmentObject private var service: ItemLinkService<I>
    
    var kind: String?
    var id: I.ID
    var label: () -> L
    
    public init(_ kind: String? = nil, id: I.ID, for: I.Type, label: @escaping () -> L) {
        self.id = id
        self.kind = kind
        self.label = label
    }
    
    public init(_ kind: String? = nil, item: I, label: @escaping () -> L) {
        self.id = item.id
        self.kind = kind
        self.label = label
    }
    
    public var body: some View {
        Button(action: {
            service(kind, id: id)
        }, label: label)
    }
}
