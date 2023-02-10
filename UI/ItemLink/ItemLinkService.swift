import SwiftUI
import Combine

public class ItemLinkService<I: Identifiable>: ObservableObject {
    let publisher: PassthroughSubject<Payload, Never> = PassthroughSubject()
    
    struct Payload {
        var id: I.ID
        var kind: String?
    }
    
    public func callAsFunction(_ kind: String? = nil, id: I.ID) {
        publisher.send(.init(id: id, kind: kind))
    }
    
    public func callAsFunction(_ kind: String? = nil, item: I) {
        publisher.send(.init(id: item.id, kind: kind))
    }
}
