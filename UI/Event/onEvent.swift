import SwiftUI

public extension View {
    func onEvent<T>(_ name: String, ofType: T.Type, action: @escaping (T) -> Void) -> some View {
        modifier(EventConsumerModifer(name: name, ofType: ofType, action: action))
    }
}

fileprivate struct EventConsumerModifer<T>: ViewModifier {
    @EnvironmentObject private var event: Event
    var name: String
    var ofType: T.Type
    var action: (T) -> Void
    
    func body(content: Content) -> some View {
        content
            .onReceive(event.publisher) {
                if $0.0 == name, let object = $0.1 as? T {
                    action(object)
                }
            }
    }
}
