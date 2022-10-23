import SwiftUI

public extension View {
    func alert<E: LocalizedError & Equatable>(_ error: E?) -> some View {
        alert(error) {}
    }
    
    func alert<E: LocalizedError & Equatable, A: View>(_ error: E?, @ViewBuilder actions: @escaping ()->A) -> some View {
        modifier(AlertErrorModifier(error: error, actions: actions))
    }
}

fileprivate struct AlertErrorModifier<E: LocalizedError & Equatable, A: View>: ViewModifier {
    var error: E?
    var actions: () -> A
    @State private var isPresented = false
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: $isPresented, error: error, actions: actions)
            .task(id: error) {
                isPresented = error != nil
            }
    }
}
