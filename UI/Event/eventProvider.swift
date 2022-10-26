import SwiftUI

public extension View {
    func eventProvider() -> some View {
        modifier(EventProviderModifer())
    }
}

fileprivate struct EventProviderModifer: ViewModifier, Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
    
    @StateObject private var event = Event()
    
    func body(content: Content) -> some View {
        content
            .environmentObject(event)
            .environment(\.sendEvent, event.send)
    }
}
