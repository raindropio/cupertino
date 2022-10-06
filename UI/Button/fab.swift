import SwiftUI

public extension View {
    func fab<B>(_ buttons: @escaping () -> B) -> some View where B: View {
        modifier(Fab(buttons: buttons))
    }
}

fileprivate struct Fab<B: View>: ViewModifier {
    @Environment(\.editMode) private var editMode
    var buttons: () -> B
    
    func body(content: Content) -> some View {
        let hide = editMode?.wrappedValue == .active
        
        content
//            ._safeAreaInsets(.init(top: 0, leading: 0, bottom: 60, trailing: 0))
            .overlay(alignment: .bottomTrailing) {
                buttons()
                    .buttonStyle(.fab)
                    .opacity(hide ? 0 : 1)
                    .scaleEffect(hide ? 0 : 1)
                    .padding(.trailing, 20)
                    .ignoresSafeArea(.keyboard)
            }
    }
}
