import SwiftUI
import Combine
import UI
import API

public extension View {
    func spotlightEvents(onPress: @escaping (SpotlightPressed) -> Void) -> some View {
        modifier(SpotlightEvents(onPress: onPress))
    }
}

fileprivate struct SpotlightEvents: ViewModifier {
    @StateObject private var event = SpotlightEvent()    
    var onPress: (SpotlightPressed) -> Void
    
    func body(content: Content) -> some View {
        content
            .environmentObject(event)
            .onReceive(event.pressed, perform: onPress)
    }
}

class SpotlightEvent: ObservableObject {
    fileprivate let pressed: PassthroughSubject<SpotlightPressed, Never> = PassthroughSubject()
    
    func press(_ of: SpotlightPressed) {
        self.pressed.send(of)
    }
}

public enum SpotlightPressed {
    case collection(UserCollection)
    case raindrop(Raindrop)
    case find(FindBy)
    case cancel
}
