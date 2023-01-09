import SwiftUI
import Combine
import UI
import API

extension Spotlight {
    struct Events: ViewModifier {
        @StateObject private var event = SpotlightEvent()
        @EnvironmentObject private var app: AppRouter
        @Environment(\.dismiss) private var dismiss
        @Environment(\.dismissSearch) private var dismissSearch
        
        var find: FindBy

        func body(content: Content) -> some View {
            content
                .environmentObject(event)
                .onReceive(event.tap) {
                    switch $0 {
                    case .collection(let collection):
                        app.browse(collection)
                        dismiss()
                        
                    case .raindrop(let raindrop):
                        app.preview(raindrop.link)
                        dismiss()
                        
                    case .find:
                        app.browse(find)
                        dismissSearch()
                    }
                }
        }
    }
}

class SpotlightEvent: ObservableObject {
    fileprivate let tap: PassthroughSubject<Tap, Never> = PassthroughSubject()
    
    func tap(_ of: Tap) {
        self.tap.send(of)
    }
}

extension SpotlightEvent {
    enum Tap {
        case collection(UserCollection)
        case raindrop(Raindrop)
        case find
    }
}
